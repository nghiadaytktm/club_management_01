var TablesDatatables = function() {
  return {
    init: function() {
      App.datatables();
      $('#example-datatable').dataTable();
      $('.datatable-public').dataTable();
    }
  };
}();
