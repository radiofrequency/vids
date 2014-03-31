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
    selection = document.getElementById("uploadfile")
    i = 0
    skip = false
    #while i < selection.files.length
    #  ext = selection.files[i].name.substr(-3)
    #  skip = true  if ext isnt "mp4" and ext isnt "m4v" and ext isnt "fv4"
    #  i++
    #alert "choose a video file" if skip
    if not skip
      $("form").hide();
      $("form").submit()
      $(".loading").show();
    return true;


  resize = ->
    videoObject = $("video")
    videoObject.width($(window).width())
    console.log("resize")
    #videoObject.height($(window).height())

  $("video").width($(window).width())

  #('video', 'DOMNodeInserted', resize);
  $(window).resize(resize);

