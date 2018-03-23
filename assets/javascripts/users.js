
	$(document).ready(function(){
		$(function(){
				$('#total-order-count').text($('#order-history>table>tbody>tr').length);
			});
			$('.vertical>.nav-tabs').stickyTabs();
			
	});