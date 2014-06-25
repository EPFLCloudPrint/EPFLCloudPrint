
$(document).ready ->
  if Dropbox.isBrowserSupported()
    $('#dropboxButton').show().click ->
      Dropbox.choose {
        success: (fs) ->
          n = fs.length
          fs.forEach (f) ->
            $.post 'php/dropbox.php', {dropbox_url: f.link, file_name: f.name}, (e) ->
              rep = try JSON.parse(e) catch exeption then {'error_code' : -1}
              addFile { file_name: rep['file_name'], server_file_name: rep['server_file_name'] }
              if --n is 0
                $("#tickPath").show()
                $('#printButton').removeClass('_disabled')
        linkType: "direct"
        multiselect: true
        extensions: ['.pdf']
      }
      showPrint()
