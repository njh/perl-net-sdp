use Module::Build;

my $build = Module::Build->new
(
	module_name => 'Net::SDP',
	script_files => [
		'examples/sdp2rat',
	],
	license => 'perl',
	build_requires => {
		'Module::Build' => '0.18'
	},
	requires => {
		'perl'	=> '5.5.0',
		'Sys::Hostname' => 0,
		'Net::hostent' => 0,
	},
	
	create_makefile_pl => 'passthrough',
	
	recommends => {
		'LWP::Simple' => 0,
	},
);

$build->create_build_script;
