Dim array1 '①100表示该文件夹最多的文件数，如果文件数大于100请自行修改
Dim source '①100表示该文件夹最多的文件数，如果文件数大于100请自行修改
Set fs = CreateObject("Scripting.FileSystemObject")
rem Set f = fs.GetFolder(left(Wscript.ScriptFullName,len(Wscript.ScriptFullName)-len(Wscript.ScriptName))) '②此处表示xls所在的文件夹，请根据需要自行修改


Sub Conv(folderName)
	Set f = fs.GetFolder(folderName) '②此处表示xls所在的文件夹，请根据需要自行修改
	Set fc = f.Files
	i = 0
	For Each f1 In fc
		array1 = f1.Name
		Ext = fs.GetExtensionName(array1)
		Ext = LCase(Ext)
		If Ext = "xls" Then '③此处表示转换类型
			source = f & "\" & array1
			dest = source & "x"
			If fs.FileExists(dest) Then
				rem Wscript.Echo dest
				fs.DeleteFile dest, True
			End If
			
			Set ExcelApp = CreateObject("Excel.Application")
			Set ExcelXls = ExcelApp.Workbooks.Open(source)
			ExcelXls.SaveAs dest,51
			ExcelXls.Close
			Set ExcelXls = Nothing
			ExcelApp.Quit
			Set ExcelApp = Nothing

			fs.DeleteFile source, True
		End If
		i = i + 1
	Next

	Set fc = f.SubFolders
	For Each f1 in fc
		s = folderName & f1.name & "\"
		rem Wscript.Echo s
		Call Conv(s)
	Next
End Sub


curFolder = left(Wscript.ScriptFullName,len(Wscript.ScriptFullName)-len(Wscript.ScriptName))
Wscript.Echo curFolder & "	Start"
Call Conv(curFolder)
Wscript.Echo "Conv OK"
