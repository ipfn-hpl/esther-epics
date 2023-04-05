#!/usr/bin/env python
"""
"""

from PyQt6.QtCore import (QDateTime, Qt, QTimer)
from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import (QApplication, QCheckBox, QComboBox, QDateTimeEdit,
        QDial, QDialog, QGridLayout, QGroupBox, QHBoxLayout, QLabel, QLineEdit,
        QProgressBar, QPushButton, QRadioButton, QScrollBar, QSizePolicy,
        QSlider, QStyleFactory, QTableWidget, QTabWidget, QTextEdit,
        QVBoxLayout, QWidget, QTableWidgetItem)
# QSpinBox
from PyQt6.QtGui import (QDoubleValidator, QPixmap)
from epics import caget, caput, cainfo
# import os

# os.environ['EPICS_CA_ADDR_LIST'] = '10.10.136.128'
# os.environ['EPICS_CA_ADDR_LIST'] = 'localhost 192.168.1.110'

# os.environ['EPICS_CA_AUTO_ADDR_LIST'] = 'NO'

# Constants 
R_GAS = 8.31446 # J / mol / K
T_REF = 273.15  # K
VOL_DRIVER = 50.35
PV_PREFIX = 'Esther:gas:'

N_EDIT = Qt.ItemFlag.ItemIsEnabled

def setTableNonEditItem(row, col, table,  value):
    item = QTableWidgetItem(f'{value:0.2f}')
    item.setFlags(Qt.ItemFlag.ItemIsEnabled)
    table.setItem(row,col,item)

class WidgetGasFilling(QDialog):
    def __init__(self, parent=None):
        super(WidgetGasFilling, self).__init__(parent)
        self.mfcTemp = dict()
        self.mfcFlowSp = dict()
        self.ptPress = dict()

        self.originalPalette = QApplication.palette()
        styleComboBox = QComboBox()
        styleComboBox.addItems(QStyleFactory.keys())

        styleLabel = QLabel("&Style:")
        styleLabel.setBuddy(styleComboBox)

        self.useStylePaletteCheckBox = QCheckBox("&Use style's standard palette")
        self.useStylePaletteCheckBox.setChecked(True)

        disableWidgetsCheckBox = QCheckBox("&Disable widgets")

        self.createTopLeftGroupBox()
        self.createTopRightGroupBox()
        #self.createBottomLeftTabWidget()
        self.createBottomTabWidget()

        styleComboBox.textActivated.connect(self.changeStyle)
        self.useStylePaletteCheckBox.toggled.connect(self.changePalette)
#        item = QTableWidgetItem(f'{self.tHeNorm:0.2f}')
#        item.setFlags(Qt.ItemFlag.ItemIsEnabled)
        disableWidgetsCheckBox.toggled.connect(self.topLeftGroupBox.setDisabled)
        disableWidgetsCheckBox.toggled.connect(self.topRightTabWidget.setDisabled)
#        disableWidgetsCheckBox.toggled.connect(self.bottomLeftTabWidget.setDisabled)
#        disableWidgetsCheckBox.toggled.connect(self.bottomRightGroupBox.setDisabled)
        disableWidgetsCheckBox.toggled.connect(self.bottomTabWidget.setDisabled)

        topLayout = QHBoxLayout()
        topLayout.addWidget(styleLabel)
        topLayout.addWidget(styleComboBox)
        topLayout.addStretch(1)
        topLayout.addWidget(self.useStylePaletteCheckBox)
        topLayout.addWidget(disableWidgetsCheckBox)

        mainLayout = QGridLayout()
        mainLayout.addLayout(topLayout, 0, 0, 1, 2)
        mainLayout.addWidget(self.topLeftGroupBox, 1, 0)
        #mainLayout.addWidget(self.topRightGroupBox, 1, 1)

        mainLayout.addWidget(self.topRightTabWidget , 1, 1)
        mainLayout.addWidget(self.bottomTabWidget, 2, 0, 1, 2)

        mainLayout.setRowStretch(0, 0)
        mainLayout.setRowStretch(1, 1)
        mainLayout.setRowStretch(2, 2)
        mainLayout.setColumnStretch(0, 1)
        mainLayout.setColumnStretch(1, 2)

        self.setLayout(mainLayout)

        self.setWindowTitle("Gas Filling Parameters")
        #self.changeStyle('Windows')
        self.changeStyle('Fusion')

    def changeStyle(self, styleName):
        QApplication.setStyle(QStyleFactory.create(styleName))
        self.changePalette()

    def changePalette(self):
        if (self.useStylePaletteCheckBox.isChecked()):
            QApplication.setPalette(QApplication.style().standardPalette())
        else:
            QApplication.setPalette(self.originalPalette)

    def createTopLeftGroupBox(self):
        self.topLeftGroupBox = QGroupBox("Group 1")

        #radioButton1 = QRadioButton("He Flushing")
        #radioButton2 = QRadioButton("N2 Flushing")
#        radioButton3 = QRadioButton("Radio button 3")
        #radioButton1.setChecked(True)

        checkBox = QCheckBox("Tri-state check box")
        checkBox.setTristate(True)
        checkBox.setCheckState(Qt.CheckState.PartiallyChecked)

        epicsGetButton = QPushButton("Epics Get PVs")
        epicsGetButton.setDefault(True)
        epicsGetButton.clicked.connect(self.getEpics)
        epicsPutButton = QPushButton("Epics Put PVs")
        epicsPutButton.setDefault(True)
        epicsPutButton.clicked.connect(self.putEpics)
        self.tempEdit = QLineEdit('14.5')
        validator = QDoubleValidator()  # Create validator.
        validator.setRange( -10.0, 100.0, 2)
        self.tempEdit.setValidator(validator)
        self.pv901Offset = QLineEdit('0.15')
        labelText = "<P><b><i><font color='#ff0001' font_size=4>"
        labelText +="Flushing Gas"
        labelText +="</font></i></b></P></br>"
        self.gasMode = QLabel('He')
        pressPushButton = QPushButton("Calc Press")
        pressPushButton.setDefault(True)
        pressPushButton.clicked.connect(self.calcPress)
        layout = QGridLayout() # QVBoxLayout()
        layout.addWidget(QLabel(labelText), 0, 0)
        layout.addWidget(self.gasMode, 0, 1)
        #layout.addWidget(QLabel('Flushing Gas Mode'), 0, 0)
        #layout.addWidget(radioButton2, 0, 1)
        #layout.addWidget(radioButton1, 0, 0)
        #layout.addWidget(radioButton2, 0, 1)
        layout.addWidget(epicsGetButton, 1, 0)
        layout.addWidget(pressPushButton, 1, 1)
        layout.addWidget(epicsPutButton, 1, 2)
        #layout.addWidget(QLabel('MFC601 Temp'), 2, 0)
        #layout.addWidget(self.tempEdit, 2, 1)
        layout.addWidget(QLabel('PV901 Offset'), 3, 0)
        layout.addWidget(self.pv901Offset, 3, 1)
        #layout.addWidget(checkBox)
        #layout.setRowStretch(2, 1)
        #layout.addStretch(1)
        self.topLeftGroupBox.setLayout(layout)

    def calcPress(self):
        tPfill = float(self.tableGasFill.item(0,0).text())
        tHe = float(self.tableGasFill.item(0,1).text())
        tH2 = float(self.tableGasFill.item(0,2).text())
        tO2 = float(self.tableGasFill.item(0,3).text())
        pSum = tHe + tH2 + tO2
        self.tHeNorm = tHe * tO2
        self.tH2Norm = tH2 * tO2
        item = QTableWidgetItem(f'{self.tHeNorm:0.2f}')
        item.setFlags(Qt.ItemFlag.ItemIsEnabled)
        self.tableGasFill.setItem(1,1, item)
        item = QTableWidgetItem(f'{self.tH2Norm:0.2f}')
        item.setFlags(Qt.ItemFlag.ItemIsEnabled)
        self.tableGasFill.setItem(1,2, item)
        #self.tableGasFill.setItem(1,1, QTableWidgetItem(f'{self.tHeNorm:0.2f}'))
        #self.tableGasFill.setItem(1,2, QTableWidgetItem(f'{self.tH2Norm:0.2f}'))
        #print(f"Sum Value: {pSum}")
        pPartAmbHe = tPfill * tHe / pSum
        setTableNonEditItem(2, 1, self.tableGasFill, pPartAmbHe)
        # self.tableGasFill.setItem(2,1, QTableWidgetItem(f'{pPartAmbHe:0.2f}'))
        pPartAmbH2 = tPfill * tH2 / pSum
        # self.tableGasFill.setItem(2,2, QTableWidgetItem(f'{pPartAmbH2:0.2f}'))
        setTableNonEditItem(2, 2, self.tableGasFill, pPartAmbH2)
        pPartAmbO2 = tPfill * tO2 / pSum
        # self.tableGasFill.setItem(2,3, QTableWidgetItem(f'{pPartAmbO2:0.2f}'))
        setTableNonEditItem(2, 3, self.tableGasFill,  pPartAmbO2)
        tempAbs = self.mfcTemp['601'] + T_REF
       # tempabs = float(self.tempEdit.text())  + T_REF
        pPartRefHe = pPartAmbHe * T_REF / tempAbs
        # self.tableGasFill.setItem(3,1, QTableWidgetItem(f'{pPartRefHe:0.2f}'))
        setTableNonEditItem(3, 1, self.tableGasFill, pPartRefHe)
        pPartRefH2 = pPartAmbH2 * T_REF / tempAbs
        # self.tableGasFill.setItem(3,2, QTableWidgetItem(f'{pPartRefH2:0.2f}'))
        setTableNonEditItem(3, 2, self.tableGasFill, pPartRefH2)
        pPartRefO2 = pPartAmbO2 * T_REF / tempAbs
        # self.tableGasFill.setItem(3,3, QTableWidgetItem(f'{pPartRefO2:0.2f}'))
        setTableNonEditItem(3, 3, self.tableGasFill, pPartRefO2)

        volAmbHe = pPartAmbHe  * VOL_DRIVER
        #volRefHe = pPartRefHe  * VOL_DRIVER
        volRefHe2 = float(self.tableSetPoints.item(1,3).text())
        volAmbHe2 = volRefHe2 * tempAbs / T_REF
        volAmbHe1 = volAmbHe - volAmbHe2 - VOL_DRIVER
        volRefHe1 = volAmbHe1 * T_REF / tempAbs

        volAmbO2 = pPartAmbO2  * VOL_DRIVER
        # self.tableSetPoints.setItem(0,0, QTableWidgetItem(f'{volAmbO2:0.2f}'))
        setTableNonEditItem(0, 0, self.tableSetPoints, volAmbO2)
        volRefO2 = pPartRefO2  * VOL_DRIVER
        self.tableSetPoints.setItem(1,0, QTableWidgetItem(f'{volRefO2:0.2f}'))

        self.tableSetPoints.setItem(0,1, QTableWidgetItem(f'{volAmbHe1:0.2f}'))
        self.tableSetPoints.setItem(1,1, QTableWidgetItem(f'{volRefHe1:0.2f}'))
        volAmbH2 = pPartAmbH2  * VOL_DRIVER
        self.tableSetPoints.setItem(0,2, QTableWidgetItem(f'{volAmbH2:0.2f}'))
        volRefH2 = pPartRefH2  * VOL_DRIVER
        self.tableSetPoints.setItem(1,2, QTableWidgetItem(f'{volRefH2:0.2f}'))
        self.tableSetPoints.setItem(0,3, QTableWidgetItem(f'{volAmbHe2:0.2f}'))

        dPO2 = volAmbO2 / 10000 * 200
        self.tableSetPoints.setItem(2,0, QTableWidgetItem(f'{dPO2:0.2f}'))
        dPHe1 = volAmbHe1 / 10000 * 200 / 2.0
        self.tableSetPoints.setItem(2,1, QTableWidgetItem(f'{dPHe1:0.2f}'))
        dPH2 = volAmbH2 / 10000 * 200
        self.tableSetPoints.setItem(2,2, QTableWidgetItem(f'{dPH2:0.2f}'))
        dPHe2 = volAmbHe2 / 10000 * 200 / 2.0
        self.tableSetPoints.setItem(2,3, QTableWidgetItem(f'{dPHe2:0.2f}'))

        fPO2 = self.ptPress['201'] - dPO2
        self.tableSetPoints.setItem(3,0, QTableWidgetItem(f'{fPO2:0.2f}'))
        fPHe1 = self.ptPress['301'] - dPHe1
        self.tableSetPoints.setItem(3,1, QTableWidgetItem(f'{fPHe1:0.2f}'))
        fPH2 = self.ptPress['401'] - dPH2
        self.tableSetPoints.setItem(3,2, QTableWidgetItem(f'{fPH2:0.2f}'))
        fPHe2 = self.ptPress['501'] - dPHe2
        self.tableSetPoints.setItem(3,3, QTableWidgetItem(f'{fPHe2:0.2f}'))

        minO2 = volRefO2 / 1e3 / self.mfcFlowSp['201'] * 60
        self.tableSetPoints.setItem(4,0, QTableWidgetItem(f'{minO2:0.2f}'))
        minHe1 = volRefHe1 / self.mfcFlowSp['601']
        self.tableSetPoints.setItem(4,1, QTableWidgetItem(f'{minHe1:0.2f}'))
        minO2 =( 0.8 * volRefO2 / self.mfcFlowSp['201'] + 0.2 * volRefO2 / 0.4) / 1e3 * 60
        self.tableSetPoints.setItem(4,2, QTableWidgetItem(f'{minO2:0.2f}'))
        minHe2 = volRefHe2 / self.mfcFlowSp['601']
        self.tableSetPoints.setItem(4,3, QTableWidgetItem(f'{minHe2:0.2f}'))

        self.pSp_O2 = volAmbO2 / VOL_DRIVER
        self.tableSetPoints.setItem(5,0, QTableWidgetItem(f'{self.pSp_O2:0.2f}'))
        self.pSp_He1 = self.pSp_O2 + volAmbHe1 / VOL_DRIVER
        self.tableSetPoints.setItem(5,1, QTableWidgetItem(f'{self.pSp_He1:0.2f}'))
        self.pSp_H2 = self.pSp_He1 + volAmbH2 / VOL_DRIVER
        self.tableSetPoints.setItem(5,2, QTableWidgetItem(f'{self.pSp_H2:0.2f}'))
        self.pSp_He2 = self.pSp_H2 + volAmbHe2 / VOL_DRIVER
        self.tableSetPoints.setItem(5,3, QTableWidgetItem(f'{self.pSp_He2:0.2f}'))

    def getEpics(self):
        self.mfcTemp['201'] = caget(PV_PREFIX + 'MFC201_FTEMP')
        self.mfcTemp['401'] = caget(PV_PREFIX + 'MFC401_FTEMP')
        self.mfcTemp['601'] = caget(PV_PREFIX + 'MFC601_FTEMP')
        self.mfcFlowSp['201'] = caget(PV_PREFIX + 'MFC201_FFLOW_SP')
        self.mfcFlowSp['401'] = caget(PV_PREFIX + 'MFC401_FFLOW_SP')
        self.mfcFlowSp['601'] = caget(PV_PREFIX + 'MFC601_FFLOW_SP')
        self.ptPress['201'] = caget(PV_PREFIX + 'PT201')
        self.ptPress['301'] = caget(PV_PREFIX + 'PT301')
        self.ptPress['401'] = caget(PV_PREFIX + 'PT401')
        self.ptPress['501'] = caget(PV_PREFIX + 'PT501')
        self.tableMfc.setItem(1,0,QTableWidgetItem(f"{self.mfcTemp['601']:0.2f}"))
        self.tableMfc.setItem(1,1,QTableWidgetItem(f"{self.mfcTemp['401']:0.2f}"))
        self.tableMfc.setItem(1,2,QTableWidgetItem(f"{self.mfcTemp['201']:0.2f}"))
        
        gasM = caget(PV_PREFIX + 'GAS_MODE', as_string=True)
        self.gasMode.setText(gasM)
        #mfc601Temp = caget('Esther:gas:' + 'MFC601_FTEMP')
        #self.tempEdit.setText(f'{mfc601Temp:0.1f}')

    def putEpics(self):
        caput(PV_PREFIX + 'PT901_SP_O', self.pSp_O2)
        caput(PV_PREFIX + 'PT901_SP_HE1', self.pSp_He1)
        caput(PV_PREFIX + 'PT901_SP_H', self.pSp_H2)
        caput(PV_PREFIX + 'PT901_SP_HE2', self.pSp_He2)

    def createTopRightGroupBox2(self):
        self.topRightGroupBox = QGroupBox("Group 2")

        togglePushButton = QPushButton("Toggle Push Button")
        togglePushButton.setCheckable(True)
        #RPump1press = caget('ISTTOK:central:RPump1-Pressure')

        layout = QGridLayout() #QVBoxLayout()
        layout.addWidget(togglePushButton, 1, 0)
        layout.setRowStretch(3, 1)
        #layout.addStretch(1)
        self.topRightGroupBox.setLayout(layout)


    def createTopRightGroupBox(self):
        self.topRightTabWidget = QTabWidget()
        self.topRightTabWidget.setSizePolicy(QSizePolicy.Policy.Preferred,
                QSizePolicy.Policy.Preferred)
        #        QSizePolicy.Policy.Ignored)

        tab1 = QWidget()
        self.tableGasFill = QTableWidget(4, 4)
        self.tableGasFill.setHorizontalHeaderLabels(("P_Filling","He","H2","O2"))
        self.tableGasFill.setVerticalHeaderLabels(("Target",'TargNormO2',"Partial (Ref)","Partial (Abs)"))
        self.tableGasFill.setItem(0,0,QTableWidgetItem("30"))
        self.tableGasFill.setItem(0,1,QTableWidgetItem("8.0"))
        itemNonEdit = QTableWidgetItem("2.0")
        itemNonEdit.setFlags(Qt.ItemFlag.NoItemFlags)
        #itemNonEdit.setFlags(itemNonEdit.flags() & ~Qt.ItemFlag.ItemIsEditable)
        self.tableGasFill.setItem(0,2, itemNonEdit)
        self.tableGasFill.setItem(0,3,QTableWidgetItem("1.2"))
        itemO2Norm = QTableWidgetItem("1.0")
        itemO2Norm.setFlags(itemNonEdit.flags())
        self.tableGasFill.setItem(1,3, itemO2Norm)

        tab2 = QWidget()
        self.tableMfc = QTableWidget(2, 3)
        self.tableMfc.setHorizontalHeaderLabels(("601 N2/He (ln/min)","H2 (m3/h)","O2"))
        self.tableMfc.setVerticalHeaderLabels(("Flow","Temperature"))
        self.tableMfc.setItem(0,0,QTableWidgetItem("45.0"))
        self.tableMfc.setItem(0,1,QTableWidgetItem("1.5"))
        self.tableMfc.setItem(0,2,QTableWidgetItem("1.5"))

        tab1hbox = QHBoxLayout()
        tab1hbox.setContentsMargins(5, 5, 5, 5)
        tab1hbox.addWidget(self.tableGasFill)
        tab1.setLayout(tab1hbox)
        
        tab2hbox = QHBoxLayout()
        tab2hbox.setContentsMargins(5, 5, 5, 5)
        tab2hbox.addWidget(self.tableMfc)
        tab2.setLayout(tab2hbox)

        labelPng = QLabel()
        pixmap = QPixmap('estherSpTable.png')
        labelPng.setPixmap(pixmap.scaled(768, 512, Qt.AspectRatioMode.KeepAspectRatio))
        labelPng.resize(pixmap.width(), pixmap.height())

        tab3 = QWidget()
        tab3hbox = QHBoxLayout()
        tab3hbox.setContentsMargins(5, 5, 5, 5)
        tab3hbox.addWidget(labelPng)
        tab3.setLayout(tab3hbox)


        self.topRightTabWidget.addTab(tab1, "&Target")
        self.topRightTabWidget.addTab(tab2, "&MFCs")
        self.topRightTabWidget.addTab(tab3, "&Reference")
        self.topRightTabWidget.adjustSize()

    def createBottomTabWidget(self):
        self.bottomTabWidget = QTabWidget()
        self.bottomTabWidget.setSizePolicy(QSizePolicy.Policy.Preferred,
                QSizePolicy.Policy.Preferred)
        #        QSizePolicy.Policy.Ignored)

        tab1 = QWidget()
        self.tableSetPoints = QTableWidget(6, 4)

        self.tableSetPoints.setHorizontalHeaderLabels(("O2","He1","H2","He2"))
        self.tableSetPoints.setVerticalHeaderLabels(("Litre Ambient","Litre Norm","dP bottle",'Bottle Final Press','Filling min','P_setpoint'))
        self.tableSetPoints.setItem(0,0,QTableWidgetItem("900"))
        self.tableSetPoints.setItem(0,1,QTableWidgetItem("80.0"))
        self.tableSetPoints.setItem(0,2,QTableWidgetItem("20.0"))
        self.tableSetPoints.setItem(0,3,QTableWidgetItem("105.0"))
        self.tableSetPoints.setItem(1,3,QTableWidgetItem("100.0"))
        self.tableSetPoints.setCurrentCell(1,3)
        
        tab1hbox = QHBoxLayout()
        tab1hbox.setContentsMargins(5, 5, 5, 5)
        tab1hbox.addWidget(self.tableSetPoints)
        tab1.setLayout(tab1hbox)
        self.bottomTabWidget.addTab(tab1, "&SetPoints")
        self.bottomTabWidget.adjustSize()

if __name__ == '__main__':

    import sys

    app = QApplication(sys.argv)
    gallery = WidgetGasFilling()
    gallery.show()
    sys.exit(app.exec())

# vim: syntax=python ts=4 sw=4 sts=4 sr et
