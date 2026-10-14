/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org
Copyright (c) 2013-2014 Chukong Technologies Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#include "CCFileUtils.h"

#include <stack>
#include <assert.h>

#define CC_SAFE_DELETE(p)           do { delete (p); (p) = nullptr; } while(0)
#define CC_SAFE_DELETE_ARRAY(p)     do { if(p) { delete[] (p); (p) = nullptr; } } while(0)
#define CC_SAFE_FREE(p)             do { if(p) { free(p); (p) = nullptr; } } while(0)
#define CC_SAFE_RELEASE(p)          do { if(p) { (p)->release(); } } while(0)
#define CC_SAFE_RELEASE_NULL(p)     do { if(p) { (p)->release(); (p) = nullptr; } } while(0)
#define CC_SAFE_RETAIN(p)           do { if(p) { (p)->retain(); } } while(0)
#define CC_BREAK_IF(cond)           if(cond) break

#define CCASSERT
#define CCLOG printf

using namespace std;


FileUtils* FileUtils::s_sharedFileUtils = nullptr;


void FileUtils::destroyInstance()
{
    CC_SAFE_DELETE(s_sharedFileUtils);
}

FileUtils::FileUtils()
{
}

FileUtils::~FileUtils()
{
}


bool FileUtils::init()
{
    _searchPathArray.push_back(_defaultResRootPath);
    _searchResolutionsOrderArray.push_back("");
    return true;
}

void FileUtils::purgeCachedEntries()
{
    _fullPathCache.clear();
}



unsigned char* FileUtils::getFileData(const std::string& filename, const char* mode, ssize_t *size)
{
    unsigned char * buffer = nullptr;
    CCASSERT(!filename.empty() && size != nullptr && mode != nullptr, "Invalid parameters.");
    *size = 0;
    do
    {
        // read the file from hardware
        const std::string fullPath = fullPathForFilename(filename);
        FILE *fp = fopen(fullPath.c_str(), mode);
        CC_BREAK_IF(!fp);
        
        fseek(fp,0,SEEK_END);
        *size = ftell(fp);
        fseek(fp,0,SEEK_SET);
        buffer = (unsigned char*)malloc(*size);
        *size = fread(buffer,sizeof(unsigned char), *size,fp);
        fclose(fp);
    } while (0);
    
    if (! buffer)
    {
        std::string msg = "Get data from file(";
        msg.append(filename).append(") failed!");
        
        CCLOG("%s", msg.c_str());
    }
    return buffer;
}


std::string FileUtils::getPathForFilename(const std::string& filename, const std::string& resolutionDirectory, const std::string& searchPath)
{
    std::string file = filename;
    std::string file_path = "";
    size_t pos = filename.find_last_of("/");
    if (pos != std::string::npos)
    {
        file_path = filename.substr(0, pos+1);
        file = filename.substr(pos+1);
    }
    
    // searchPath + file_path + resourceDirectory
    std::string path = searchPath;
    path += file_path;
    path += resolutionDirectory;
    
    path = getFullPathForDirectoryAndFilename(path, file);
    
    //CCLOG("getPathForFilename, fullPath = %s", path.c_str());
    return path;
}


std::string FileUtils::fullPathForFilename(const std::string &filename)
{
    if (filename.empty())
    {
        return "";
    }
    
    if (isAbsolutePath(filename))
    {
        return filename;
    }

    // Already Cached ?
    auto cacheIter = _fullPathCache.find(filename);
    if( cacheIter != _fullPathCache.end() )
    {
        return cacheIter->second;
    }
    
    // Get the new file name.
    const std::string newFilename( filename );
    
	std::string fullpath;
    
    for (auto searchIt = _searchPathArray.cbegin(); searchIt != _searchPathArray.cend(); ++searchIt)
    {
        for (auto resolutionIt = _searchResolutionsOrderArray.cbegin(); resolutionIt != _searchResolutionsOrderArray.cend(); ++resolutionIt)
        {
            fullpath = this->getPathForFilename(newFilename, *resolutionIt, *searchIt);
            
            if (fullpath.length() > 0)
            {
                // Using the filename passed in as key.
                _fullPathCache.insert(std::make_pair(filename, fullpath));
                return fullpath;
            }
        }
    }
    
    CCLOG("cocos2d: fullPathForFilename: No file found at %s. Possible missing file.", filename.c_str());

    // XXX: Should it return nullptr ? or an empty string ?
    // The file wasn't found, return the file name passed in.
    return filename;
}

std::string FileUtils::fullPathFromRelativeFile(const std::string &filename, const std::string &relativeFile)
{
    return relativeFile.substr(0, relativeFile.rfind('/')+1) + filename;
}

void FileUtils::setSearchResolutionsOrder(const std::vector<std::string>& searchResolutionsOrder)
{
    bool existDefault = false;
    _fullPathCache.clear();
    _searchResolutionsOrderArray.clear();
    for(auto iter = searchResolutionsOrder.cbegin(); iter != searchResolutionsOrder.cend(); ++iter)
    {
        std::string resolutionDirectory = *iter;
        if (!existDefault && resolutionDirectory == "")
        {
            existDefault = true;
        }
        
        if (resolutionDirectory.length() > 0 && resolutionDirectory[resolutionDirectory.length()-1] != '/')
        {
            resolutionDirectory += "/";
        }
        
        _searchResolutionsOrderArray.push_back(resolutionDirectory);
    }
    if (!existDefault)
    {
        _searchResolutionsOrderArray.push_back("");
    }
}

void FileUtils::addSearchResolutionsOrder(const std::string &order,const bool front)
{
    std::string resOrder = order;
    if (!resOrder.empty() && resOrder[resOrder.length()-1] != '/')
        resOrder.append("/");
    if (front) {
        _searchResolutionsOrderArray.insert(_searchResolutionsOrderArray.begin(), resOrder);
    } else {
        _searchResolutionsOrderArray.push_back(resOrder);
    }
}

const std::vector<std::string>& FileUtils::getSearchResolutionsOrder()
{
    return _searchResolutionsOrderArray;
}

const std::vector<std::string>& FileUtils::getSearchPaths() const
{
    return _searchPathArray;
}

void FileUtils::setSearchPaths(const std::vector<std::string>& searchPaths)
{
    bool existDefaultRootPath = false;
    
    _fullPathCache.clear();
    _searchPathArray.clear();
    for (auto iter = searchPaths.cbegin(); iter != searchPaths.cend(); ++iter)
    {
        std::string prefix;
        std::string path;
        
        if (!isAbsolutePath(*iter))
        { // Not an absolute path
            prefix = _defaultResRootPath;
        }
        path = prefix + (*iter);
        if (path.length() > 0 && path[path.length()-1] != '/')
        {
            path += "/";
        }
        if (!existDefaultRootPath && path == _defaultResRootPath)
        {
            existDefaultRootPath = true;
        }
        _searchPathArray.push_back(path);
    }
    
    if (!existDefaultRootPath)
    {
        //CCLOG("Default root path doesn't exist, adding it.");
        _searchPathArray.push_back(_defaultResRootPath);
    }
}

void FileUtils::addSearchPath(const std::string &searchpath,const bool front)
{
    std::string prefix;
    if (!isAbsolutePath(searchpath))
        prefix = _defaultResRootPath;

    std::string path = prefix + searchpath;
    if (path.length() > 0 && path[path.length()-1] != '/')
    {
        path += "/";
    }
    if (front) {
        _searchPathArray.insert(_searchPathArray.begin(), path);
    } else {
        _searchPathArray.push_back(path);
    }
}



std::string FileUtils::getFullPathForDirectoryAndFilename(const std::string& directory, const std::string& filename)
{
    // get directory+filename, safely adding '/' as necessary 
    std::string ret = directory;
    if (directory.size() && directory[directory.size()-1] != '/'){
        ret += '/';
    }
    ret += filename;
    
    // if the file doesn't exist, return an empty string
    if (!isFileExistInternal(ret)) {
        ret = "";
    }
    return ret;
}

bool FileUtils::isFileExist(const std::string& filename) const
{
    // If filename is absolute path, we don't need to consider 'search paths' and 'resolution orders'.
    if (isAbsolutePath(filename))
    {
        return isFileExistInternal(filename);
    }
    
    // Already Cached ?
    auto cacheIter = _fullPathCache.find(filename);
    if( cacheIter != _fullPathCache.end() )
    {
        return true;
    }
    
    // Get the new file name.
    const std::string newFilename( filename );
    
	std::string fullpath;
    
    for (auto searchIt = _searchPathArray.cbegin(); searchIt != _searchPathArray.cend(); ++searchIt)
    {
        for (auto resolutionIt = _searchResolutionsOrderArray.cbegin(); resolutionIt != _searchResolutionsOrderArray.cend(); ++resolutionIt)
        {
            fullpath = const_cast<FileUtils*>(this)->getPathForFilename(newFilename, *resolutionIt, *searchIt);
            
            if (!fullpath.empty())
            {
                // Using the filename passed in as key.
                const_cast<FileUtils*>(this)->_fullPathCache.insert(std::make_pair(filename, fullpath));
                return true;
            }
        }
    }
    return false;
}

bool FileUtils::isAbsolutePath(const std::string& path) const
{
    return (path[0] == '/');
}

