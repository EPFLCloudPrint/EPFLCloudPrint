
$(document).ready ->
  if Dropbox.isBrowserSupported()
    $('#dropboxButton').show().click ->
      $('#tickPath').hide()
      Dropbox.choose {
        success: (fs) ->
          if(fs.length > 0)
            showPrint()
            console.log 'show'
            m = fs.length
            n = fs.length
            fs.forEach (f) ->
              $.post 'php/dropbox.php', {dropbox_url: f.link, file_name: f.name}, (e) ->
                rep = try JSON.parse(e) catch exeption then {'error_code' : -1}
                addFile { file_name: rep['file_name'], server_file_name: rep['server_file_name'] }
                if --n is 0 and m is 1
                  $("#cloudPath").attr('fill', 'white')
                  $("#tickPath").show()
                  $('#printButton').removeClass('_disabled')
                else if n is 0
                  $('#tickPath').hide()
                  $('#cloudPath').attr('fill', 'url(#progression)')
                  $('#progression stop').attr 'offset', 100 + "%"
                  $('#printButton').removeClass('_disabled')
                  setTimeout (-> 
                    $("#cloudPath").attr('fill', 'white')
                    $("#tickPath").show()
                    ), 1000
                else
                  $('#tickPath').hide()
                  $('#cloudPath').attr('fill', 'url(#progression)')
                  $('#progression stop').attr 'offset', (m - n) / m * 100 + "%"

        linkType: "direct"
        multiselect: true
        extensions: ['.pdf']
      }
