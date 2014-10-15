node default {
	hiera_include('classes')
  
	$mgmt_node = hiera_hash('mgmt_node')
	ensure_resource('class', 'vclmgmt', $mgmt_node)
	
	$srcdirs = hiera_hash('srcdirs')
	create_resources(file, $srcdirs, { tag => "srcdir" })
	$images = hiera_hash('base_images')
	create_resources(vclmgmt::baseimage, $images)
	
	$xcat_templates = hiera_hash('xtemplates')
	create_resources(xcat::template, $xcat_templates)

	hiera_include('afterclasses')
	
	firewall { "120 accept puppet dashboard 8080":
      		chain => 'INPUT',
		proto => 'tcp',
		dport => 8080,
		action => 'accept',
		destination => $::fqdn,
	}

	firewall { "125 accept puppet agent 8140":
      		chain => 'INPUT',
		proto => 'tcp',
		dport => 8140,
		action => 'accept',
		destination => $::fqdn,
	}

	File <| tag=="srcdir" |> -> Vclmgmt::Baseimage <| |>	
}

