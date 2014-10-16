node default {
	hiera_include('classes')
	
	$pkgs = hiera_hash('packages', undef)
	if $pkgs != undef {
	  create_resources(package, $pkgs)
	}
  
	$images = hiera_hash('base_images', undef)
	if $images != undef {
	  create_resources(vclmgmt::baseimage, $images)
	}
	
	$xcat_templates = hiera_hash('xtemplates', undef)
	if $xcat_templates != undef {
	  create_resources(xcat::template, $xcat_templates)
	}

	$firewalls = hiera_hash('firewalls', undef)
	if $firewalls != undef {
	  create_resources(firewall, $firewalls)
	}
  
}

