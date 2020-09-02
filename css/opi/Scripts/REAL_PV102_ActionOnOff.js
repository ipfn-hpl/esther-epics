importPackage(Packages.org.csstudio.opibuilder.scriptUtil);
var pv = widget.getPVByName("Esther:gas:PV102");
var value = PVUtil.getLong(pv);
if(value==0)
	pv.setValue("CLOSED");
else
	pv.setValue("OPEN");