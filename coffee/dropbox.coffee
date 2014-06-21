$(document).ready ->
  if Dropbox.isBrowserSupported()
    $('.dropbox._button').show().click ->
      Dropbox.choose
        success: (fs) ->
          addFile {dropbox_url: f.link, file_name: f.name} for f in fs
          $("#tick_path").show()
          showPrint()
          $('.print._button').removeClass('_disabled')
        linkType: "direct"
        multiselect: true
        extensions: ['.pdf']
