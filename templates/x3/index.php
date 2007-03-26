<?php defined( "_VALID_MOS" ) or die( "Direct Access to this location is not allowed." );$iso = split( '=', _ISO );echo '<?xml version="1.0" encoding="'. $iso[1] .'"?' .'>';?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<?php mosShowHead(); ?>
<meta http-equiv="Content-Type" content="text/html;><?php echo _ISO; ?>" />
<?php if ( $my->id ) { initEditor(); } ?>
<link href="<?php echo $mosConfig_live_site;?>/templates/<?php echo $mainframe-> getTemplate(); ?>/css/template_css.css" rel="stylesheet" type="text/css"/>
</head>
	<body class="bodies">


<a href="http://www.statcounter.com/" target="_blank"><img src="http://c18.statcounter.com/counter.php?sc_project=1910801&java=0&security=34790f19&invisible=1" 
 alt="simple hit counter" border="0"></a> 

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-110766-2";
urchinTracker();
</script>

		<div class="header">
			<div class="wrap">
				<div class="searchbox">
		   			<?php mosLoadModules('user4'); ?>
    			</div>
				<h1><?php echo $mosConfig_sitename; ?></h1>
				<div id="mainlevel-nav">
					<?php mosLoadModules ( 'user3' ); ?>
    			</div>
			</div>
		</div>
		
		<div class="wrap">
			<div class="sectwide">
				<?php if (mosCountModules('user1')) { ?>
                  <div id="user1">
                    <?php mosLoadModules ( 'user1', -0 ); ?>
					<? } ?>
                  </div>
                 <div id="r_sect"><?php mosLoadModules ( 'left' ); ?></div>
			<div id="l_sect"><?php mosMainBody( 'user4' ); ?></div>
			<div id="footer">
				<p><?php include_once('includes/footer.php'); ?></p>
			</div>
		</div>
	</div>
</div>
</body>
</html>