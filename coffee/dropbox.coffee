
$(document).ready ->
  if Dropbox.isBrowserSupported()
    $('#dropboxButton').show().click ->
      Dropbox.choose
        success: (fs) ->
          addFile {dropbox_url: f.link, file_name: f.name} for f in fs
          $("#tickPath").show()
          showPrint()
          $('#printButton').removeClass('_disabled')
        linkType: "direct"
        multiselect: true
        extensions: ['.pdf']
