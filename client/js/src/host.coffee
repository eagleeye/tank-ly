options =
	render: 'div'
	ecLevel: 'H'
#	minVersion: parseInt($("#minversion").val(), 10),

	fill: '#000'
	background: null

	text: window.location.origin + "/m/#{roomId}"
	size: 400,
	radius: 0.2
	quiet: 1,

	mode: 2,

	mSize: 0.1,
	mPosX: 0.5,
	mPosY: 0.5,

	label: 'tank.ly'
	fontname: 'Ubuntu'
	fontcolor: '#000'

$ ->
	$("#qr").empty().qrcode(options);

	$('.toggle-qr').click ->
		$('#qr').slideToggle()