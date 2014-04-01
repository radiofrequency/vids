// Generated by CoffeeScript 1.7.1
(function() {
  $(function() {
    var resize;
    (function(d, s, id) {
      var fjs, js;
      js = void 0;
      fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {
        return;
      }
      js = d.createElement(s);
      js.id = id;
      js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=678619382180097";
      fjs.parentNode.insertBefore(js, fjs);
    })(document, "script", "facebook-jssdk");
    $(".btn-upload").on("click", function() {
      return $('.file-upload').click();
    });
    $(".file-upload").on("change", function() {
      $("form").hide();
      $("form").submit();
      $(".loading").show();
      return true;
    });
    resize = function() {
      var videoObject;
      videoObject = $("video");
      return videoObject.width($(window).width());
    };
    $("video").width($(window).width());
    return $(window).resize(resize);
  });

}).call(this);
