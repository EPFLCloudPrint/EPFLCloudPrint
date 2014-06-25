$(document).ready(function(){
  $('#pagesheet').change(togglePageLayout);
});


function togglePageLayout(){
  if(this.value == 4){
    $('#viewlayout').slideDown();
  }else{
    $('#viewlayout').slideUp();
  }
}
