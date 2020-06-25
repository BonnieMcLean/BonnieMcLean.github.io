$(document).ready(function () {
    var $rows = $('tbody#report tr')
   
     var $filters = $('.table-filter').change(function(){
       var filterArr = $filters.filter(function(){
          return this.value
       }).map(function(){
          var $el = $(this);
          var value = $el.is('select') ? $el.find(':selected').text() :$el.val()  
          return {
            col: $el.data('col'),
            value: value.toLowerCase()
          }
       }).get();
       if(!filterArr.length){
         $rows.show()
       }else{
         $rows.hide().filter(function(){
            var $row = $(this)
            return filterArr.every(function(filterObj, i){
               var cellText = $row.find('td').eq(filterObj.col).text().toLowerCase();             
              return  cellText.includes(filterObj.value);
            })
         }).show()
       }
     })
   

});

