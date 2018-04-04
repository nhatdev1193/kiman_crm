$(function(){
  (function contractSearchForm(){
    // TODO: Check change event when input date value mm/dd/yyyy
    let $formID = $('#contract-seach-form');

    $formID.find('select').change(function(){
      $formID.submit();
    });
  })();
});