(function(){var containers = [{"id":"grv-personalization-127","url":"http://rma-api.gravity.com/v1/api/intelligence/w2?sg=0764e1b55cf9992e246aa7770f416d34&pl=127&ug=&ad=&sp=3583&pfurl=&cburl=&epl=","width":"100.0%","height":"423px","siteGuid":"0764e1b55cf9992e246aa7770f416d34","placement":127,"userGuid":"","widgetLoaderHooks":[]}];
/*
  Provides GravityUtils.includeJs() to dynamically source JavaScripts.
*/

/*
  @param {String}   url
  @param {Function} onSuccess Called on script load success.
  @param {Function} onError   Called on script load error.
*/

if (!window.GravityUtils) {
  window.GravityUtils = {};
}

if (!window.GravityUtils.includeJs) {
  window.GravityUtils.includeJs = function(url, onSuccess, onError) {
    var loadHandled, loadHandler, s, someScript;
    if (onSuccess == null) {
      onSuccess = (function() {});
    }
    if (onError == null) {
      onError = (function() {});
    }
    s = document.createElement('script');
    s.async = true;
    loadHandled = false;
    loadHandler = function() {
      loadHandled = true;
      s.onreadystatechange = s.onload = null;
      return onSuccess();
    };
    s.onreadystatechange = function() {
      if (!loadHandled && (!this.readyState || this.readyState === 'complete' || this.readyState === 'loaded')) {
        return loadHandler();
      }
    };
    s.onload = function() {
      if (!loadHandled) {
        return loadHandler();
      }
    };
    if (s.addEventListener) {
      s.addEventListener('error', onError, false);
    } else if (s.attachEvent) {
      s.attachEvent('onerror', onError);
    }
    s.src = url;
    someScript = document.getElementsByTagName('script')[0];
    return someScript.parentNode.insertBefore(s, someScript);
  };
}

/*
  Provides GravityUtils.insertStyleBlock() to insert style blocks into the page. Especially useful in situations where
  external stylesheets aren't feasible, or when styles need to be introduced for async loaded elements that aren't
  present at the time of style determination.
*/

/*
  @param {String} css The inner CSS content of the style block.
*/

if (!window.GravityUtils) {
  window.GravityUtils = {};
}

if (!window.GravityUtils.insertStyleBlock) {
  window.GravityUtils.insertStyleBlock = function(css) {
    var head, style;
    head = document.head || document.getElementsByTagName('head')[0];
    style = document.createElement('style');
    style.type = 'text/css';
    if (style.styleSheet) {
      style.styleSheet.cssText = css;
    } else {
      style.appendChild(document.createTextNode(css));
    }
    return head.appendChild(style);
  };
}

var documentElem, _ref;

documentElem = window.document.documentElement;

/*
  @param {Object} elem                Native DOM element.
  @param {Number} inViewThreshold     Square pixel area of element that must be in viewport in order to consider it in view.
                                      Default is 100x100 square.
  @param {Number} absMinViewThreshold If the entire widget area is less than inViewThreshold (i.e. a very small widget),
                                      this absolute min view threshold will be used instead considering that the widget
                                      would otherwise never be counted as "in view."

  @return {Boolean}
*/


if ((_ref = window.grvElemInView) == null) {
  window.grvElemInView = function(elem, inViewThreshold, absMinViewThreshold) {
    var elemArea, elemHeight, elemRect, elemWidth, heightInView, inView, widthInView, windowHeight, windowWidth;
    if (inViewThreshold == null) {
      inViewThreshold = 10000;
    }
    if (absMinViewThreshold == null) {
      absMinViewThreshold = 4000;
    }
    inView = false;
    elemRect = elem.getBoundingClientRect();
    windowHeight = documentElem.clientHeight;
    elemWidth = elemRect.right - elemRect.left;
    elemHeight = elemRect.bottom - elemRect.top;
    elemArea = elemWidth * elemHeight;
    if ((absMinViewThreshold <= elemArea && elemArea <= inViewThreshold)) {
      inViewThreshold = absMinViewThreshold;
    }
    if ((elemRect.top >= 0 && elemRect.top < windowHeight) || (elemRect.bottom >= 0 && elemRect.bottom < windowHeight) || (elemRect.top < 0 && elemRect.bottom >= windowHeight)) {
      windowWidth = documentElem.clientWidth;
      if ((elemRect.left >= 0 && elemRect.left < windowWidth) || (elemRect.right >= 0 && elemRect.right < windowWidth) || (elemRect.left < 0 && elemRect.right >= windowWidth)) {
        widthInView = Math.min(elemRect.right, windowWidth) - Math.max(elemRect.left, 0);
        heightInView = Math.min(elemRect.bottom, windowHeight) - Math.max(elemRect.top, 0);
        if (widthInView * heightInView > inViewThreshold) {
          inView = true;
        }
      }
    }
    return inView;
  };
}


if (!window.GravityUtils) {
  window.GravityUtils = {};
}

if (!GravityUtils.urlHashContains) {
  GravityUtils.urlHashContains = function(paramName) {
    try {
      return new RegExp('([&?#]|^)' + paramName + '([&=]|$)').test(location.hash);
    } catch (e) {
      return false;
    }
  };
}

if (!GravityUtils.urlHashParamValue) {
  GravityUtils.urlHashParamValue = function(paramName, defaultValue) {
    var matches, _ref;
    if (defaultValue == null) {
      defaultValue = null;
    }
    try {
      matches = new RegExp('([&?#]|^)' + paramName + '=([^&]*)').exec(location.hash);
      return (_ref = matches != null ? matches[2] : void 0) != null ? _ref : defaultValue;
    } catch (e) {
      return defaultValue;
    }
  };
}

var WidgetLoaderHookCtx;

WidgetLoaderHookCtx = (function() {
  /*
      @param {jQuery} @$
      @param {Object} @container
      @param {GrvWidgetVars} [@widgetVars=]
  */

  function WidgetLoaderHookCtx($, container, widgetVars) {
    this.$ = $;
    this.container = container;
    this.widgetVars = widgetVars != null ? widgetVars : null;
  }

  WidgetLoaderHookCtx.prototype.beforeFetchWidget = function() {
    var hook, _base, _i, _len, _ref, _ref1, _results;
    try {
      this.globalWidgetHook();
      _ref1 = (_ref = this.container.widgetLoaderHooks) != null ? _ref : [];
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        hook = _ref1[_i];
        if (hook.beforeFetchWidget != null) {
          _results.push(typeof (_base = eval(hook.beforeFetchWidget)) === "function" ? _base(this) : void 0);
        }
      }
      return _results;
    } catch (e) {
      if ((typeof console !== "undefined" && console !== null ? console.warn : void 0) != null) {
        console.warn('Gravity: Exception during beforeFetchWidget:');
        return console.warn(e);
      }
    }
  };

  WidgetLoaderHookCtx.prototype.widgetRequestSent = function(widgetUrl, widgetType) {
    var hook, _base, _i, _len, _ref, _ref1, _results;
    try {
      _ref1 = (_ref = this.container.widgetLoaderHooks) != null ? _ref : [];
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        hook = _ref1[_i];
        if (hook.widgetRequestSent != null) {
          _results.push(typeof (_base = eval(hook.widgetRequestSent)) === "function" ? _base(this, widgetUrl, widgetType) : void 0);
        }
      }
      return _results;
    } catch (e) {
      if ((typeof console !== "undefined" && console !== null ? console.warn : void 0) != null) {
        console.warn('Gravity: Exception during widgetRequestSent:');
        return console.warn(e);
      }
    }
  };

  WidgetLoaderHookCtx.prototype.impressionError = function(errorCtx) {
    var hook, _base, _i, _len, _ref, _ref1, _results;
    try {
      _ref1 = (_ref = this.container.widgetLoaderHooks) != null ? _ref : [];
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        hook = _ref1[_i];
        if (hook.impressionError != null) {
          _results.push(typeof (_base = eval(hook.impressionError)) === "function" ? _base(this, errorCtx) : void 0);
        }
      }
      return _results;
    } catch (e) {
      if ((typeof console !== "undefined" && console !== null ? console.warn : void 0) != null) {
        console.warn('Gravity: Exception during impressionError:');
        return console.warn(e);
      }
    }
  };

  WidgetLoaderHookCtx.prototype.afterBuildIframe = function($iframe) {
    var hook, _base, _i, _len, _ref, _ref1, _results;
    try {
      _ref1 = (_ref = this.container.widgetLoaderHooks) != null ? _ref : [];
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        hook = _ref1[_i];
        if (hook.afterBuildIframe != null) {
          _results.push(typeof (_base = eval(hook.afterBuildIframe)) === "function" ? _base(this, $iframe) : void 0);
        }
      }
      return _results;
    } catch (e) {
      if ((typeof console !== "undefined" && console !== null ? console.warn : void 0) != null) {
        console.warn('Gravity: Exception during afterBuildIframe:');
        return console.warn(e);
      }
    }
  };

  WidgetLoaderHookCtx.prototype.onPostMessage = function(postMessageEvent) {
    var hook, _base, _i, _len, _ref, _ref1, _results;
    try {
      _ref1 = (_ref = this.container.widgetLoaderHooks) != null ? _ref : [];
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        hook = _ref1[_i];
        if (hook.onPostMessage != null) {
          _results.push(typeof (_base = eval(hook.onPostMessage)) === "function" ? _base(this, postMessageEvent) : void 0);
        }
      }
      return _results;
    } catch (e) {
      if ((typeof console !== "undefined" && console !== null ? console.warn : void 0) != null) {
        console.warn('Gravity: Exception during onPostMessage:');
        return console.warn(e);
      }
    }
  };

  /*
      In the future, WidgetLoaderHook table should take after WidgetHook table in which a scopedKey is used to hook into
      widgets. When that happens, this "hard coded" global widget loader hook could be moved to link to EverythingKey and
      stored in the DB like other hooks.
  */


  WidgetLoaderHookCtx.prototype.globalWidgetHook = function() {
    try {
      if (/\bgrvUsesAbp\s*=\s*1\b/.test(document.cookie.toString())) {
        return this.container.url += (this.container.url.indexOf('?') === -1 ? '?' : '&') + 'abp=1';
      }
    } catch (ex) {
      if (typeof console !== "undefined" && console !== null ? console.log : void 0) {
        console.log('Grv suppressing exception:');
        return console.log(ex);
      }
    }
  };

  return WidgetLoaderHookCtx;

})();

/*
  Shows the attribution modal, lazily initting it if necessary.

  Can be called either from same window (JSONP widgets) or via postMessage from widget to widget loader (iframe widgets).

  @requires insertStyleBlock.coffee
*/


window.grvShowAttributionModal = function($) {
  var $box, $closeBtn, $document, $overlay, $window, bindOverlayEvents, closeDialog, closeOnEscape, maintainOverlaySize, openDialog, setOverlaySize, unbindOverlayEvents, _ref,
    _this = this;
  $window = $(window);
  $document = $(document);
  if ((_ref = this.isVisible) == null) {
    this.isVisible = false;
  }
  if (!this.$overlay) {
    GravityUtils.insertStyleBlock("#grv_attr_overlay {\n  background: rgb(0,0,0);\n  background: rgba(0,0,0,0.6);\n  position: absolute;\n  top: 0px;\n  left: 0px;\n  z-index: 1000;\n  font-family: 'Source Sans Pro', 'helvetica neue', helvetica, sans-serif, arial;\n  display: none;\n}\n#grv_attr_box {\n  background: #fff url(//static.grvcdn.com/personalization/gravity_com_logo.932f1275dd5d743c1ae799763120a12c.png) no-repeat center 30px;\n  border-radius: 4px;\n  -moz-border-radius: 4px;\n  -webkit-border-radius: 4px;\n  padding: 85px 30px 30px;\n  width: 330px;\n  text-align: center;\n  position: absolute;\n  display: none;\n}\n#grv_attr_box p.grv_p {\n  font-size: 15px;\n  line-height: 18px;\n  margin-bottom: 10px;\n  font-weight: 300;\n  color: #505050;\n}\na.grv_btn_blue {\n  background: #09f;\n  border-radius: 4px;\n  -moz-border-radius: 4px;\n  -webkit-border-radius: 4px;\n  color: #fff !important;\n  font-size: 16px;\n  font-weight: 200;\n  padding: 6px 12px;\n  outline: none;\n  text-decoration: none !important;\n}\na.grv_btn_blue:hover {\n  background: #f90;\n}\n#grv_attrib_close_btn {\n  background: #505050;\n  color: #fff;\n  width: 30px;\n  height: 30px;\n  line-height: 30px;\n  vertical-align: middle;\n  text-align: center;\n  font-size: 15px;\n  font-weight: 100;\n  position: absolute;\n  top: -15px;\n  right: -15px;\n  display: block;\n  border-radius: 30px;\n  -moz-border-radius: 30px;\n  -webkit-border-radius: 30px;\n  cursor: pointer;\n}\n#grv_attrib_close_btn:hover {\n  background: #09f;\n}");
    this.$overlay = $("<div id=\"grv_attr_overlay\">\n  <div id=\"grv_attr_box\">\n    <p class=\"grv_p\">These stories are recommended for you by Gravity.</p>\n    <p class=\"grv_p\">The recommendations may include stories from other partners, some of whom pay to include their content here.</p>\n    <a href=\"http://www.gravity.com/consumers\" target=\"_blank\" class=\"grv_btn_blue\">Learn More</a>\n    <div id=\"grv_attrib_close_btn\">X</div>\n  </div>\n</div>").hide().appendTo('body');
    this.$box = $('#grv_attr_box');
    this.$closeBtn = $('#grv_attrib_close_btn');
  }
  $overlay = this.$overlay;
  $box = this.$box;
  $closeBtn = this.$closeBtn;
  setOverlaySize = function() {
    return $overlay.height($document.height()).width($document.width());
  };
  maintainOverlaySize = function() {
    var _this = this;
    if (this.resizeTimeoutHandle) {
      clearTimeout(this.resizeTimeoutHandle);
    }
    return this.resizeTimeoutHandle = setTimeout((function() {
      _this.resizeTimeoutHandle = null;
      return setOverlaySize();
    }), 50);
  };
  bindOverlayEvents = function() {
    $window.resize(maintainOverlaySize);
    $document.keyup(closeOnEscape);
    $overlay.add($closeBtn).click(closeDialog);
    return $box.click(function(e) {
      return e.stopPropagation();
    });
  };
  unbindOverlayEvents = function() {
    $window.unbind('resize', maintainOverlaySize);
    $document.unbind('keyup', closeOnEscape);
    $overlay.add($closeBtn).unbind('click', closeDialog);
    return $box.unbind('click');
  };
  closeDialog = function() {
    _this.isVisible = false;
    unbindOverlayEvents();
    return $box.stop().fadeOut('fast', function() {
      return $overlay.stop().fadeOut('slow');
    });
  };
  closeOnEscape = function(e) {
    if (e.which === 27) {
      return closeDialog();
    }
  };
  openDialog = function() {
    _this.isVisible = true;
    setOverlaySize();
    $box.add($overlay).css('opacity', 0).show();
    $box.css('top', $window.scrollTop() + $window.height() / 2 - $box.outerHeight() / 2);
    $box.css('left', $window.scrollLeft() + $window.width() / 2 - $box.outerWidth() / 2);
    bindOverlayEvents();
    return $overlay.animate({
      opacity: 1
    }, 'slow', function() {
      return $box.animate({
        opacity: 1
      }, 'fast', function() {
        if (window.focus) {
          window.focus();
        }
        if (document.activeElement && document.activeElement.blur) {
          return document.activeElement.blur();
        }
      });
    });
  };
  if (this.isVisible) {
    return closeDialog();
  } else {
    return openDialog();
  }
};

var jqueryAssetUrl, loadWidgets, secure, _ref,
  __hasProp = {}.hasOwnProperty;

if ((_ref = window.grvPageViewId) == null) {
  window.grvPageViewId = {
    widgetLoaderWindowUrl: window.location.href,
    timeMillis: new Date().getTime().toString(),
    rand: Math.random().toString().replace('.', '').replace(/^0+/, '')
  };
}

loadWidgets = function($) {
  var $window, bindEvent, c, existsInArray, frameUrl, inputSourceUrl, isEmptyObject, lastHeight, msgDataToIframe, msgDataToIframeOnScroll, postMessageSupported, receiveMessage, showWidget, sourceUrl, unbindEvent, _base, _base1, _fn, _i, _len, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
  bindEvent = function(eventName, handler) {
    if (window.addEventListener) {
      return window.addEventListener(eventName, handler, false);
    } else if (window.attachEvent) {
      return window.attachEvent("on" + eventName, handler);
    }
  };
  unbindEvent = function(eventName, handler) {
    if (window.removeEventListener) {
      return window.removeEventListener(eventName, handler, false);
    } else if (window.detachEvent) {
      return window.detachEvent("on" + eventName, handler);
    }
  };
  $window = $(window);
  postMessageSupported = !!window.postMessage;
  msgDataToIframe = {};
  msgDataToIframeOnScroll = {};
  showWidget = function(container) {
    var cb, containerCss, containerId, _i, _len, _ref1, _ref2;
    if ((_ref1 = window.grvWidgetSuccessCallbacks) != null ? _ref1.length : void 0) {
      containerId = container.attr('id');
      _ref2 = window.grvWidgetSuccessCallbacks;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        cb = _ref2[_i];
        cb(containerId);
      }
    }
    containerCss = {
      position: 'static',
      left: 'auto',
      top: 'auto'
    };
    if (container.hasClass('grvRestore100PercentWidth')) {
      containerCss.width = '100%';
    }
    return container.css(containerCss);
  };
  if ((_ref1 = window.grvDestroyWidget) == null) {
    window.grvDestroyWidget = function(containerId) {
      var $container, clickCapReceiveMessage, elem, iframeAndContainer, iframeCollection, iframeOnScroll, iframeOnScrollCollection, key, msgDataKey, _i, _j, _len, _len1, _ref2, _ref3, _ref4;
      if (typeof console !== "undefined" && console !== null) {
        if (typeof console.log === "function") {
          console.log("Gravity: Destroying widget " + containerId);
        }
      }
      elem = document.getElementById(containerId);
      if (elem != null ? (_ref2 = elem.parentNode) != null ? _ref2.removeChild : void 0 : void 0) {
        msgDataKey = null;
        $container = null;
        _ref3 = window.grvDestroyWidget.grvIframeCollections;
        for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
          iframeCollection = _ref3[_i];
          for (key in iframeCollection) {
            if (!__hasProp.call(iframeCollection, key)) continue;
            iframeAndContainer = iframeCollection[key];
            if (!(($container = iframeAndContainer.filter('div'))[0] === elem)) {
              continue;
            }
            msgDataKey = key;
            break;
          }
        }
        if (msgDataKey) {
          delete iframeCollection[msgDataKey];
          _ref4 = window.grvDestroyWidget.grvIframeOnScrollCollections;
          for (_j = 0, _len1 = _ref4.length; _j < _len1; _j++) {
            iframeOnScrollCollection = _ref4[_j];
            for (key in iframeOnScrollCollection) {
              if (!__hasProp.call(iframeOnScrollCollection, key)) continue;
              iframeOnScroll = iframeOnScrollCollection[key];
              if (!iframeOnScrollCollection[msgDataKey]) {
                continue;
              }
              delete iframeOnScrollCollection[msgDataKey];
              break;
            }
          }
          elem.parentNode.removeChild(elem);
          if (isEmptyObject(iframeCollection)) {
            unbindEvent('message', receiveMessage);
          }
          clickCapReceiveMessage = $container != null ? $container.data('clickCapReceiveMessage.grv') : void 0;
          if (clickCapReceiveMessage != null) {
            return unbindEvent('message', clickCapReceiveMessage);
          }
        }
      }
    };
  }
  if ((_ref2 = (_base = window.grvDestroyWidget).grvIframeCollections) == null) {
    _base.grvIframeCollections = [];
  }
  if ((_ref3 = (_base1 = window.grvDestroyWidget).grvIframeOnScrollCollections) == null) {
    _base1.grvIframeOnScrollCollections = [];
  }
  window.grvDestroyWidget.grvIframeCollections.push(msgDataToIframe);
  window.grvDestroyWidget.grvIframeOnScrollCollections.push(msgDataToIframeOnScroll);
  isEmptyObject = function(obj) {
    var k;
    for (k in obj) {
      return false;
    }
    return true;
  };
  lastHeight = null;
  receiveMessage = function(event) {
    var $iframe, c, cb, container, containerId, decimalPart, hookCtx, iframeAndContainer, iframeElem, iframeSrc, intPart, is_maybe_our_message, matches, messageDomainMatches, msg, msgData, msgExtra, msg_data, msg_placement, msg_siteguid, msg_userid, newHeight, proxyToOrigin, unit, _base2, _i, _j, _len, _len1, _ref4, _ref5, _ref6, _ref7, _ref8;
    if (isEmptyObject(msgDataToIframe)) {
      unbindEvent('message', receiveMessage);
      return;
    }
    if (((_ref4 = event.data) != null ? typeof _ref4.substr === "function" ? _ref4.substr(0, 5) : void 0 : void 0) === 'json|') {
      try {
        msg = JSON.parse(event.data.substr(5));
        if (msg.grvProxyPostMessageUp != null) {
          proxyToOrigin = msg.grvProxyPostMessageUp;
          delete msg.grvProxyPostMessageUp;
          console.log('Posting Grv event %o to %s', msg, proxyToOrigin);
          return window.parent.postMessage(JSON.stringify(msg), proxyToOrigin);
        } else if ((msg != null ? msg.type : void 0) === "debugWidget") {
          return $.each(msg.scripts, function(i, script) {
            return $.getScript(script, function() {
              if (i === msg.scripts.length - 1) {
                return window.grvRenderWidgetDebugPanel($, msg);
              }
            });
          });
        }
      } catch (_error) {}
    } else if (event.data && event.origin) {
      for (_i = 0, _len = containers.length; _i < _len; _i++) {
        c = containers[_i];
        hookCtx = new WidgetLoaderHookCtx($, c);
        hookCtx.onPostMessage(event);
      }
      msg_data = typeof (_base2 = event.data).split === "function" ? _base2.split("|") : void 0;
      is_maybe_our_message = ((msg_data != null ? msg_data.length : void 0) || 0) >= 4;
      if (!is_maybe_our_message) {
        return;
      }
      msg_siteguid = msg_data[0], msg_placement = msg_data[1], msg_userid = msg_data[2], msg = msg_data[3];
      msgExtra = (_ref5 = msg_data[4]) != null ? _ref5 : null;
      msgData = "" + msg_siteguid + "|" + msg_placement + "|" + msg_userid;
      iframeAndContainer = msgDataToIframe[msgData];
      $iframe = iframeAndContainer != null ? iframeAndContainer.filter('iframe') : void 0;
      iframeSrc = $iframe != null ? $iframe.attr('src') : void 0;
      messageDomainMatches = (iframeSrc != null ? iframeSrc.indexOf(event.origin) : void 0) === 0;
      if (messageDomainMatches) {
        iframeElem = $iframe[0];
        if (iframeElem.contentWindow == null) {
          return;
        }
        if (!msgDataToIframeOnScroll[msgData]) {
          msgDataToIframeOnScroll[msgData] = function() {
            if (grvElemInView(iframeElem)) {
              $window.unbind('scroll', msgDataToIframeOnScroll[msgData]);
              return iframeElem.contentWindow.postMessage('widgetInView', '*');
            }
          };
        }
        if (msg === 'grv_show') {
          showWidget(iframeAndContainer.not('iframe'));
          iframeElem.contentWindow.postMessage('widgetShown', '*');
          $window.bind('scroll', msgDataToIframeOnScroll[msgData]);
          return msgDataToIframeOnScroll[msgData]();
        } else if (msg === 'showAttrib') {
          return window.grvShowAttributionModal($);
        } else if (((_ref6 = (matches = /^setHeight:(\d+)(\.\d+)?(px|%)?/.exec(msg))) != null ? _ref6[1] : void 0) != null) {
          intPart = matches[1];
          decimalPart = matches[2] || '';
          unit = matches[3] || 'px';
          newHeight = intPart + decimalPart + unit;
          if (newHeight !== lastHeight) {
            iframeAndContainer.height(newHeight);
            iframeElem.contentWindow.postMessage('heightUpdated', '*');
            if ($iframe.width() >= 2) {
              $iframe.css('opacity', 1);
              return msgDataToIframeOnScroll[msgData]();
            }
          }
        } else if (msg === 'grvWidgetError') {
          if ((_ref7 = window.grvWidgetErrorCallbacks) != null ? _ref7.length : void 0) {
            container = iframeAndContainer.not('iframe');
            containerId = container.attr('id');
            _ref8 = window.grvWidgetErrorCallbacks;
            for (_j = 0, _len1 = _ref8.length; _j < _len1; _j++) {
              cb = _ref8[_j];
              cb(containerId);
            }
          }
          return hookCtx.impressionError(msgExtra);
        }
      }
    }
  };
  inputSourceUrl = (_ref4 = window.gravityInsightsParams) != null ? (_ref5 = _ref4.sourceUrl) != null ? (_ref6 = _ref5.match(/^http.*/)) != null ? _ref6[0] : void 0 : void 0 : void 0;
  sourceUrl = inputSourceUrl || window.location.href;
  frameUrl = window.location.href;
  existsInArray = function(array, predicate) {
    var item, _i, _len;
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (predicate(item)) {
        return true;
      }
    }
    return false;
  };
  _fn = function(c) {
    var aolOmniPassThrough, aolOmniPassThroughJson, clickCapReceiveMessage, clickCaptureCallbacks, cobrandFromParent, container, glid, hookCtx, htmlEncodedUrl, iframe, iframeAndContainer, is100PercentWidth, k, msgData, msgDelim, msgPrefix, msgPrefixLen, realContainerWidth, toJsonLite, url, v, w2Params, wlClientTime, _ref7, _ref8;
    hookCtx = new WidgetLoaderHookCtx($, c);
    hookCtx.beforeFetchWidget();
    aolOmniPassThroughJson = null;
    if ('0' === '1') {
      toJsonLite = function(obj) {
        var key, val;
        return '{' + ((function() {
          var _results;
          _results = [];
          for (key in obj) {
            if (!__hasProp.call(obj, key)) continue;
            val = obj[key];
            _results.push('"' + key.replace(/"/g, '\\"') + '":"' + val.toString().replace(/"/g, '\\"') + '"');
          }
          return _results;
        })()).join(',') + '}';
      };
      if (window.s_265) {
        aolOmniPassThrough = {};
        if (s_265.prop1 != null) {
          aolOmniPassThrough.prop1 = s_265.prop1;
        }
        if (s_265.prop2 != null) {
          aolOmniPassThrough.prop2 = s_265.prop2;
        }
        if (s_265.prop14 != null) {
          aolOmniPassThrough.prop14 = s_265.prop14;
        }
        if (s_265.prop10 != null) {
          aolOmniPassThrough.prop10 = s_265.prop10;
        }
        if (s_265.pageURL != null) {
          aolOmniPassThrough.pageURL = s_265.pageURL;
        }
        if (s_265.prop56 != null) {
          aolOmniPassThrough.prop56 = s_265.prop56;
        }
        if (s_265.channel != null) {
          aolOmniPassThrough.prop23 = s_265.channel;
        }
        if (s_265.eVar14 != null) {
          aolOmniPassThrough.eVar14 = s_265.eVar14;
        }
        cobrandFromParent = (typeof bN !== "undefined" && bN !== null ? typeof bN.get === "function" ? bN.get('cobrand') : void 0 : void 0) || s_265.prop66;
        if (cobrandFromParent != null) {
          aolOmniPassThrough.cobrand = cobrandFromParent;
        }
        glid = typeof s_265.c_r === "function" ? s_265.c_r('UNAUTHID') : void 0;
        if (glid != null) {
          aolOmniPassThrough.glid = glid;
        }
        aolOmniPassThroughJson = toJsonLite(aolOmniPassThrough);
      }
    }
    wlClientTime = '1445246018569';
    clickCaptureCallbacks = ((_ref7 = window.grvArticleClickCaptureCbs) != null ? (_ref8 = _ref7[c.siteGuid || '']) != null ? _ref8[c.placement.toString() || ''] : void 0 : void 0) || [];
    w2Params = {
      sourceUrl: encodeURIComponent(sourceUrl),
      frameUrl: encodeURIComponent(frameUrl),
      clientTime: new Date().getTime(),
      ci: encodeURIComponent(c.id)
    };
    if (aolOmniPassThrough) {
      w2Params.aopt = encodeURIComponent(aolOmniPassThroughJson);
    }
    if (wlClientTime) {
      w2Params.wct = encodeURIComponent(wlClientTime);
    }
    if ((clickCaptureCallbacks != null ? clickCaptureCallbacks.length : void 0) && postMessageSupported) {
      if (existsInArray(clickCaptureCallbacks, function(cb) {
        return !$.isFunction(cb) && cb.preventDefaultForSponsored === false;
      })) {
        w2Params.cc = 'preventDefaultForSponsored-false';
      } else {
        w2Params.cc = '1';
      }
    }
    url = ("" + c.url + "&") + $.param({
      'pageViewId[widgetLoaderWindowUrl]': window.grvPageViewId.widgetLoaderWindowUrl,
      'pageViewId[timeMillis]': window.grvPageViewId.timeMillis,
      'pageViewId[rand]': window.grvPageViewId.rand
    }) + '&' + ((function() {
      var _results;
      _results = [];
      for (k in w2Params) {
        if (!__hasProp.call(w2Params, k)) continue;
        v = w2Params[k];
        _results.push("" + k + "=" + v);
      }
      return _results;
    })()).join('&');
    htmlEncodedUrl = $('<p />').text(url).html();
    iframe = $("<iframe frameBorder='0' scrolling='no' src='" + htmlEncodedUrl + "' />").css('overflow', 'hidden');
    c.$iframe = iframe;
    container = $("#" + c.id);
    iframeAndContainer = iframe.add(container);
    iframe.css({
      width: c.width,
      height: c.height
    });
    is100PercentWidth = /^100(\.0+)?%$/.test(c.width);
    if (is100PercentWidth && ((realContainerWidth = container.parent().width()) != null) && realContainerWidth > 1) {
      container.css('width', "" + realContainerWidth + "px").addClass('grvRestore100PercentWidth');
    } else {
      container.css('width', c.width);
    }
    container.css({
      height: c.height,
      overflow: 'hidden',
      position: 'absolute',
      top: '-10000px',
      left: '-10000px'
    });
    if (!postMessageSupported) {
      iframe.load(function() {
        return showWidget(container);
      });
    }
    iframe.appendTo(container);
    hookCtx.widgetRequestSent(url, 'iframe');
    hookCtx.afterBuildIframe(iframe);
    if (postMessageSupported) {
      msgData = "" + c.siteGuid + "|" + c.placement + "|" + c.userGuid;
      msgDataToIframe[msgData] = iframeAndContainer;
      if (clickCaptureCallbacks != null ? clickCaptureCallbacks.length : void 0) {
        msgPrefix = 'grvClk';
        msgPrefixLen = msgPrefix.length;
        msgDelim = '|';
        bindEvent('message', clickCapReceiveMessage = function(e) {
          var cb, exposedArticle, msg, msgIsFromUs, origin, parts, resolvedCallback, _j, _len1, _results;
          msg = e != null ? e.data : void 0;
          origin = e != null ? e.origin : void 0;
          msgIsFromUs = origin && c.url.indexOf(origin) === 0;
          if (msgIsFromUs && msg.substr(0, msgPrefixLen) === msgPrefix) {
            parts = msg.substr(msgPrefixLen).split(msgDelim, 2);
            if (parts.length === 2) {
              exposedArticle = {
                title: parts[0],
                url: parts[1]
              };
              _results = [];
              for (_j = 0, _len1 = clickCaptureCallbacks.length; _j < _len1; _j++) {
                cb = clickCaptureCallbacks[_j];
                resolvedCallback = null;
                if ($.isFunction(cb)) {
                  resolvedCallback = cb;
                } else if (cb.callback) {
                  resolvedCallback = cb.callback;
                }
                if (resolvedCallback != null) {
                  _results.push(resolvedCallback(c.id, exposedArticle));
                } else {
                  _results.push(typeof console !== "undefined" && console !== null ? typeof console.warning === "function" ? console.warning('Grv click capture callback ignored; invalid format given') : void 0 : void 0);
                }
              }
              return _results;
            }
          }
        });
        return container.data('clickCapReceiveMessage.grv', clickCapReceiveMessage);
      }
    }
  };
  for (_i = 0, _len = containers.length; _i < _len; _i++) {
    c = containers[_i];
    _fn(c);
  }
  return bindEvent('message', receiveMessage);
};

/*
  @requires includeJs.coffee
*/


if (window.jQuery && !false) {
  window.$grv = jQuery;
  loadWidgets($grv);
} else {
  secure = document.location.protocol === 'https:';
  jqueryAssetUrl = secure ? '//static.grvcdn.com/personalization/grv-jquery-1.8.2.min.446a642fc8237b3799365aee82b1db0c.js' : '//static.grvcdn.com/personalization/grv-jquery-1.8.2.min.446a642fc8237b3799365aee82b1db0c.js';
  window.grvJqueryLoadedCallbacks = window.grvJqueryLoadedCallbacks || [];
  window.grvJqueryLoadedCallbacks.push(loadWidgets);
  window.GravityUtils.includeJs(jqueryAssetUrl);
}
})();