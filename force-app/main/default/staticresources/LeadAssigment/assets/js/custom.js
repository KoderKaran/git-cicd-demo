$(function () {
    $(".sortable").sortable({
        tolerance: 'pointer',
        handle: '.glyphicon-move',
        revert: 'invalid',
        placeholder: 'col-xs-12 placeholder tile',
        forceHelperSize: true, 
        update: function(event, ui) {
	        /* This event is triggered when the user stopped sorting and the DOM position has changed. */
	        //console.log("New position: " + ui.item.index());
	        
	        var $leadid='';
	        $('.tile').each(function () {
		        $leadid += $(this).attr("data-lead")+', ';
		    });
	        
		    /* Lead IDs with new order (display) */
		    console.log("New Order: " + $leadid);
		    //alert($leadid);
		    
	    }
    });
    //$(".sortable").disableSelection();
    
    
    $('#addnew').on('shown.bs.collapse', function () {
	    $('.add-lead.collapse .row').effect('highlight');
	});
	
	
	
	//March 29, 2015 
	
	$(".input-switch").bootstrapSwitch();
	$('#tm-status .bootstrap-switch, #tm-status .bootstrap-switch-handle-on, #tm-status .bootstrap-switch-handle-off').click(function() {
	  	var $state = $("#switch-input").bootstrapSwitch('state');
	  	if(!$state) {
	  		$('#turnOffModal').modal({
			  backdrop: 'static'
			});
  		}
  		if($state) {
	  		$('#turnOnModal').modal({
			  backdrop: 'static'
			});
  		}
	});
	$('#turnOffModal .btn-switch').click(function() {
		var $do = $(this).data( "do" );
		if($do=='on') {
			$('#switch-input').bootstrapSwitch('state', true);
			$('#switch-input').bootstrapSwitch('labelText', 'Turn Off');
			$('#turnOffModal').modal('hide');
		}
		if($do=='off') {
			$('#switch-input').bootstrapSwitch('state', false);
			$('#switch-input').bootstrapSwitch('labelText', 'Turn On');
			$('#turnOffModal').modal('hide');
		}
		//alert($do);
	});
	$('#turnOnModal .btn-switch').click(function() {
		var $do = $(this).data( "do" );
		if($do=='on') {
			$('#switch-input').bootstrapSwitch('state', true);
			$('#switch-input').bootstrapSwitch('labelText', 'Turn Off');
			$('#turnOnModal').modal('hide');
		}
		if($do=='off') {
			$('#switch-input').bootstrapSwitch('state', false);
			$('#switch-input').bootstrapSwitch('labelText', 'Turn On');
			$('#turnOnModal').modal('hide');
		}
		//alert($do);
	});
	
	
	//var nextDate = new Date(new Date().getTime() + 24 * 60 * 60 * 1000);
	var nextDate = moment();
	$('#datetimepicker1').datetimepicker({
        minDate: nextDate,
        format:'MM/DD/YYYY'
    });
    
    $(".btn-action").click(function() {
	    
	    var $action = $(this).data("action");
	    var $target = $(this).data("target");
	    
	    if($action=='close') {
			$($target).hide();
		}
		if($action=='open') {
			$($target).fadeIn();
		}
	    
	});
    
});