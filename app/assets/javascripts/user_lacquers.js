$(function(){
  var selectedBrands = []
  var unselectedBrands = []
  var selectedColors = []
  var unselectedColors = []
  
  $('.brands').click(function(e){
    e.preventDefault();
    e.stopPropagation();
    $('table h2').hide();
    var brand = this.id
    $(this).toggleClass("selected");

    $("tr[brand='"+ brand +"']").toggleClass("selected");

    selectedBrands = []
    unselectedBrands = []

    $('.btn.brands.selected').each(function(){
      selectedBrands.push(this.text);
    });

    $('.btn.brands').not('.selected').each(function(){
      unselectedBrands.push(this.text);
    });

    $("tr.selected").show();
    $('tr').not('.selected').hide();
    if ($('tr.selected').length === 0){
      $('tr').show();
    }

    if (selectedBrands.length === 0) {
      if (selectedColors.length === 0) {
        $('tr').show();
      } else {
        $("tr.color-selected").show();
        $('tr').not('.color-selected').hide();
      }
    } else if (selectedColors.length > 0) {
      $("tr.selected.color-selected").show();
      $('tr').not('.selected.color-selected').hide();
    } else {
      $('tr.selected').show();
      $('tr').not('.selected').hide();
    }
    
    if (selectedBrands.length !== 0 && selectedColors.length !== 0 && $('tr').not('[style="display: none;"]').length === 0) {
      //debugger;
      $('table').append("<h2>No results for the filters you selected.</h2>");
    }

  });

  $('.colors').click(function(e){
    e.preventDefault();
    e.stopPropagation();
    $('table h2').hide();

    var color = this.id
    $(this).toggleClass("selected");

    selectedColors = []
    unselectedColors = []

    $('.btn.colors.selected').each(function(){
      selectedColors.push(this.text);
    });

    $('.btn.colors').not('.selected').each(function(){
      unselectedColors.push(this.text);
    });

    $.each(unselectedColors, function(index, color){
      $("tr."+color).removeClass("color-selected");
    })

    $.each(selectedColors, function(index, color){
      $("tr."+color).addClass("color-selected");
    })

    if (selectedBrands.length === 0) {
      if (selectedColors.length === 0) {
        $('tr').show();
      } else {
        $("tr.color-selected").show();
        $('tr').not('.color-selected').hide();
      }
    } else if (selectedColors.length > 0) {
      $("tr.selected.color-selected").show();
      $('tr').not('.selected.color-selected').hide();
    } else {
      $('tr.selected').show();
      $('tr').not('.selected').hide();
    }

    if ((selectedBrands.length !== 0) && (selectedColors.length !== 0) && ($('tr').not('[style="display: none;"]').length === 0)) {
      //debugger;
      $('table').append("<h2>No results for the filters you selected.</h2>")
    }

  });

  $('#user-lacquers-by-brand').hide();
  $('#user-lacquers-by-name').hide();
  $('#user-lacquers-by-brand-reverse').hide();
  $('#user-lacquers-by-name-reverse').hide();
  var brandSorter = $('.sort#brand');
  var nameSorter = $('.sort#name');
  var brandSorterReverse = $('.sort#brand-reverse');
  var nameSorterReverse = $('.sort#name-reverse');
  brandSorter.click(function(e){
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-name').hide();
    $('#user-lacquers-by-brand-reverse').hide();
    $('#user-lacquers-by-name-reverse').hide();
    $('#user-lacquers-by-brand').show();
  });
  nameSorter.click(function(e){
    e.stopPropagation();
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-brand').hide();
    $('#user-lacquers-by-brand-reverse').hide();
    $('#user-lacquers-by-name-reverse').hide();
    $('#user-lacquers-by-name').show();
  });
  brandSorterReverse.click(function(e){
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-brand').hide();
    $('#user-lacquers-by-name').hide();
    $('#user-lacquers-by-name-reverse').hide();
    $('#user-lacquers-by-brand-reverse').show();
  });
  nameSorterReverse.click(function(e){
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-brand').hide();
    $('#user-lacquers-by-name').hide();
    $('#user-lacquers-by-brand-reverse').hide();
    $('#user-lacquers-by-name-reverse').show();
  });
});


