importPackage(Packages.org.csstudio.opibuilder.scriptUtil);
var pv = widget.getPVByName("loc://PV503");
var value = PVUtil.getLong(pv);
if(value==0)
	pv.setValue(1);
else
	pv.setValue(0);