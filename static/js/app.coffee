$ ->
  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    return  if d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=678619382180097"
    fjs.parentNode.insertBefore js, fjs
    return
  ) document, "script", "facebook-jssdk"

  $(".btn-upload").on "click" ,->
    $('.file-upload').click()

  $(".file-upload").on "change" , ->
    $("form").hide();
    $("form").submit()
    $(".loading").show();
    return true;


  resize = ->
    videoObject = $("video")
    videoObject.width($(window).width())

  $("video").width($(window).width())

  $(window).resize(resize);

