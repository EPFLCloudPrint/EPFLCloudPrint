$(document).ready ->
  if Dropbox.isBrowserSupported()
    $('.dropbox._button').show().click ->
      Dropbox.choose
        success: (fs) ->
          for f in fs
            files.push
              dropbox_url: f.link
              file_name: f.name
          updateFilesList()
          $("#tick_path").show();
          toggleThePrintMode()
          $('.print._button').removeClass('_disabled')
        linkType: "direct"
        multiselect: true
        extensions: ['.pdf']
