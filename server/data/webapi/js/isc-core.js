var flash = {};
flash.orgWidth = 1920;
flash.orgHeight = 1080;
flash.left = 0;


_calWidthHeight();


(function($){
	
	/*
		- Chuyển đổi image thành bgimage
		- Cách gọi hàm: tenclass.ConvertImg2Bg(), ---- vd: jQuery('.imgscale').ImgScale();
		- chú ý dùng khi phải có height
	*/ 
	
    $.fn.convertImg2Bg = function(options){
        var settings = $.extend({
            isimage : false
        },options);
		
        return this.each(function(){
            jQuery(this).css({
                'background-image' : 'url('+jQuery(this).find('img').attr('src')+')',
                'background-size' : 'cover',
                'background-position' : ' 50% 50%'
            })
            if(!settings.isimage) {
                jQuery(this).find('img').css({'opacity':0});
            }
        });
    };

	/*
		- Canh giữa 1 box
		- Cách gọi hàm: tenclass.ImgScale(), ---- vd: jQuery('.imgscale').ImgScale();
	*/

    $.fn.calMidCenBox = function(options){
        var settings = $.extend({
            // These are the defaults.
            middle: true,
            center: true
        }, options );
        return this.each(function(){
            if(settings.middle) {
                jQuery(this).css({
                    'position' : 'absolute',
                    'top' : ($(this).parent().height() - $(this).height())/2

                });
            }
            if(settings.center) {
                jQuery(this).css({
                    'position' : 'absolute',
                    'left' : ($(this).parent().width() - $(this).width())/2,
                });
            }


        });
    };
	
	/*
		- Scale Image theo trình duyệt
		- Sử dụng bằng cách thêm thuộc tính data-width, data-height, data-left, data-top, data-bottom, data-right vào html
		- Cách gọi hàm: tenclass.ImgScale(), ---- vd: jQuery('.imgscale').ImgScale();
	*/

	$.fn.imgScale = function(options){
        var settings = $.extend({}, options );
		
		if(flash.scaleW < flash.scaleH){
			flash.scaleW = flash.scaleH
		}
        return this.each(function(){
            if( jQuery(this).data('width')) {
				var widthImg = jQuery(this).data('width');
				jQuery(this).css({'width': Math.round(flash.scaleW * widthImg)})
				
			}
			if( jQuery(this).data('height') ){
				var heightImg = jQuery(this).data('height');
				jQuery(this).css({'height': Math.round(flash.scaleW * heightImg)})
			}
			if ( jQuery(this).data('left')) {
				var leftImg = jQuery(this).data('left');
				jQuery(this).css({'left': Math.round(flash.scaleW * leftImg)})
			}
			if ( jQuery(this).data('top')) {
				var topImg = jQuery(this).data('top');
				jQuery(this).css({'top': Math.round(flash.scaleW * topImg)})
			}
			if ( jQuery(this).data('bottom')) {
				var bottomImg = jQuery(this).data('bottom');
				jQuery(this).css({'bottom': Math.round(flash.scaleW * topImg)})
			}
			if ( jQuery(this).data('right')) {
				var rightImg = jQuery(this).data('right');
				jQuery(this).css({'right': Math.round(flash.scaleW * topImg)})
			}
	
	
		});
    };
	
	/*
		- Scale Image theo trình duyệt
		- Cách gọi hàm: tenclass.ResizeImg(), ---- vd: jQuery('.layers-resize').ResizeImg();
	*/
	
	$.fn.resizeImg = function(options){
       var settings = $.extend({
            ratio : 0
        },options);
		
		
        return this.each(function(){
           ratio = screen.height / flash.orgHeight;
			jQuery(this).css({
				"transform" : "scale(" + ratio + ", " + ratio + ")",
				"transform-origin": 'top'
			});
	
		});
    };

})(jQuery);

/*
	- calculate screen
	-
*/

function _calWidthHeight() {
    var screen = {};
    screen.width = jQuery(window).width();
    screen.height = jQuery(window).height();

    flash.scaleW = screen.width / flash.orgWidth;
    flash.scaleH = screen.height / flash.orgHeight;

    if (flash.scaleW > flash.scaleH) {
        flash.newWidth = flash.orgWidth * flash.scaleW;
        flash.newHeight = flash.orgHeight * flash.scaleW;

    } else {
        flash.newWidth = flash.orgWidth * flash.scaleH;
        flash.newHeight = flash.orgHeight * flash.scaleH;

    }
    flash.left = (flash.newWidth - screen.width)*(-0.5);
	
	if(isFlashInstalled){
		jQuery('.wrapper').css({
			'width': flash.newWidth,
			'height': flash.newHeight,
			'background-position-x': flash.left
		});
		jQuery(".wrapper-flash").css({
			'width': flash.newWidth,
			'height': flash.newHeight,
			'left': flash.left,
			'position': 'absolute',
			'top': 0
		});
		jQuery('body').css({
			'height' : screen.height
		});	
	}
	
var isFlashInstalled = (function(){
var b=new function(){var n=this;n.c=!1;var a="ShockwaveFlash.ShockwaveFlash",r=[{name:a+".7",version:function(n){return e(n)}},{name:a+".6",version:function(n){var a="6,0,21";try{n.AllowScriptAccess="always",a=e(n)}catch(r){}return a}},{name:a,version:function(n){return e(n)}}],e=function(n){var a=-1;try{a=n.GetVariable("$version")}catch(r){}return a},i=function(n){var a=-1;try{a=new ActiveXObject(n)}catch(r){a={activeXError:!0}}return a};n.b=function(){if(navigator.plugins&&navigator.plugins.length>0){var a="application/x-shockwave-flash",e=navigator.mimeTypes;e&&e[a]&&e[a].enabledPlugin&&e[a].enabledPlugin.description&&(n.c=!0)}else if(-1==navigator.appVersion.indexOf("Mac")&&window.execScript)for(var t=-1,c=0;c<r.length&&-1==t;c++){var o=i(r[c].name);o.activeXError||(n.c=!0)}}()};  
return b.c;
    })();   

}

/*
	- Check thiết bị mobi
	- Cách gọi hàm: tenclass.ResizeImg(), ---- vd: jQuery('.layers-resize').ResizeImg();
*/


var iscCore = {
    checkMobile : function(os) {
        var arrDevice = {
            android: /Android/i,
            ios: /iPhone|iPad|iPod/i,
            blackberry: /BlackBerry/i,
            opera: /Opera Mini/i,
            window: /IEMobile/i

        };
        var isDevice = null;

        if (os) {
            return navigator.userAgent.match(arrDevice[os]);
        }

        for (var prop in arrDevice) {
            isDevice = isDevice || iscCore.checkMobile(prop);

        }
        return isDevice;
    },

    /*getViewport: function() {
        var result = {};
        result.width = window.innerWidth;
        result.height = window.innerHeight;
        return result;
    },*/

    shareSocial: function(url){
        if(navigator.userAgent.indexOf('MSIE')!= -1) {
            winDef = 'scrollbars=no,status=no,toolbar=no,location=no,menubar=no,resizable=yes,height=430,width=550,top='.concat((screen.height - 500)/2).concat(',left=').concat((screen.width - 500)/2);
        } else {
            winDef = 'scrollbars=no,status=no,toolbar=no,location=no,menubar=no,resizable=no,height=400,width=550,top='.concat((screen.height - 500)/2).concat(',left=').concat((screen.width - 500)/2);
        }
        url = url + document.location.href;

        window.open(url,'_blank',winDef);
    },

    isFlashEnabled: function() {
        var hasFlash = false;
        try {
            var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
            if (fo) hasFlash = true;
        }
        catch (e) {
            if (navigator.mimeTypes ["application/x-shockwave-flash"] != undefined) hasFlash = true;
        }
        return hasFlash;
    },
	
	/*
	- hiển thị thông báo hoặc mở thư viện hình
	- Dùng cho Landingpage và mainsite
	- Cách gọi hàm: Popup(options)- nếu popup dùng cho nhiều loại khác nhau, Popup()- nếu popup Landingpage;
	*/
	
	Popup: function(options){
		
		jQuery('body').append('<div class="bgover" ></div>');
		jQuery('.bgover').css({'height': jQuery(document).height()}).show();
		if(options){
			jQuery('#'+options).removeClass('hidden');
		}
		jQuery('.popup').show();
		jQuery('.close,.bgover').click(function(){
			jQuery('.bgover').remove();
			jQuery('.popup').hide();
			if(jQuery('.popup').children().length > 1){
				
				jQuery('.popup').find('.hidden').siblings().addClass('hidden');
			}
			
		})
	}

};

