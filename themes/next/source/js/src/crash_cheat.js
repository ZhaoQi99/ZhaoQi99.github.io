<!--±ÀÀ£ÆÛÆ­-->
var OriginTitile = document.title;
 var titleTime;
 document.addEventListener('visibilitychange', function () {
 if (document.hidden) {
     $('[rel="icon"]').attr('href', "/img/TEP.ico");
     document.title = '¨q(¡ãA¡ã`)¨r Ò³Ãæ±ÀÀ£À² ~';
     clearTimeout(titleTime);
 }
 else {
     $('[rel="icon"]').attr('href', "/favicon.ico");
     document.title = '(?>¦Ø<*?) àæÓÖºÃÁË~' + OriginTitile;
     titleTime = setTimeout(function () {
         document.title = OriginTitile;
     }, 2000);
 }
});