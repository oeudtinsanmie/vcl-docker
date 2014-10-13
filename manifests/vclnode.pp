node /eb2\-2238\-pod20\-[tT]610\.netlabs\.ncsu\.edu/ {
	hiera_include('classes')
  
  $pkgs = hiera_array('packages', undef)
  if $pkgs != undef {
    package { $pkgs: ensure => present,}
  }
	
	$mgmt_node = hiera_hash('mgmt_node')
	ensure_resource('class', 'vclmgmt', $mgmt_node)
	
	$netlabspoddefaults = hiera('netlabs::poddefaults', {})
	$netlabspods = hiera('netlabs::pods', {})
	create_resources(vclmgmt::xcat_pod, set_defaults(generate_pods($netlabspods), $netlabspoddefaults, $mgmt_node) )
	
	$tagsrc = { tag => "srcdir" }
	$srcdirs = hiera_hash('srcdirs')
	create_resources(file, $srcdirs, $tagsrc)
	$images = hiera_hash('base_images')
	create_resources(vclmgmt::baseimage, $images)
	
	$xcat_templates = hiera_hash('xtemplates')
	create_resources(xcat::template, $xcat_templates)
	
	File <| tag=="srcdir" |> -> Vclmgmt::Baseimage <| |>
        Package['zlib-devel'] -> Package['passenger']
	Package['ruby-devel'] -> Package['passenger']
	Package['gcc-c++'] -> Package['passenger']
	Package['libcurl-devel'] -> Package['passenger']

	$puppetbase = "http://yum.puppetlabs.com"
	$defaultrepo = {
	    enabled  => 1,
	    gpgcheck => 1,
            tag   => "vclrepo",
	}
	$repos = {
		'puppetrepo' => {
			descr => 'puppet yum repo',
			baseurl => "${puppetbase}/el/${lsbmajdistrelease}/products/${architecture}",
			gpgkey => "${puppetbase}/RPM-GPG-KEY-puppetlabs",
		},
	}
	create_resources(yumrepo, $repos, $defaultrepo)

	Yumrepo['puppetrepo'] -> Package['puppet-dashboard']

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
	
}

