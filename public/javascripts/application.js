// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(document).ready(function($) {
	$.facebox.settings.closeImage = '/images/facebox/closelabel.png'
	$.facebox.settings.loadingImage = '/images/facebox/loading.gif'
  $('a[rel*=facebox]').facebox()

	$('#group_dropdown_hidden').hide();
	$('#group_dropdown').click(function() {
	  $('#group_dropdown_hidden').slideToggle( 200 );
	});

})
