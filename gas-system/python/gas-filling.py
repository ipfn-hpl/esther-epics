#!/usr/bin/env python
"""
"""

from PyQt6.QtCore import QDateTime, Qt, QTimer
from PyQt6.QtWidgets import (QApplication, QCheckBox, QComboBox, QDateTimeEdit,
        QDial, QDialog, QGridLayout, QGroupBox, QHBoxLayout, QLabel, QLineEdit,
        QProgressBar, QPushButton, QRadioButton, QScrollBar, QSizePolicy,
        QSlider, QSpinBox, QStyleFactory, QTableWidget, QTabWidget, QTextEdit,
        QVBoxLayout, QWidget, QTableWidgetItem)
from PyQt6.QtGui import QDoubleValidator
from epics import caget, caput, cainfo
import os

os.environ['EPICS_CA_ADDR_LIST'] = '10.10.136.128'
#os.environ['EPICS_CA_ADDR_LIST'] = 'localhost 192.168.1.110'

os.environ['EPICS_CA_AUTO_ADDR_LIST'] = 'NO'

# Constants 
R_GAS = 8.31446 # J / mol / K
T_REF = 273.15  # K
VOL_DRIVER = 50.35
PV_PREFIX = 'Esther:gas:'

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
        mainLayout.setRowStretch(0, 2)
        mainLayout.setRowStretch(2, 1)
        mainLayout.setColumnStretch(0, 1)
        mainLayout.setColumnStretch(1, 2)

        self.setLayout(mainLayout)

        self.setWindowTitle("Gas Filling Parameters")
        self.changeStyle('Windows')

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

        radioButton1 = QRadioButton("He Flushing")
        radioButton2 = QRadioButton("N2 Flushing")
#        radioButton3 = QRadioButton("Radio button 3")
        radioButton1.setChecked(True)

        checkBox = QCheckBox("Tri-state check box")
        checkBox.setTristate(True)
        checkBox.setCheckState(Qt.CheckState.PartiallyChecked)

        epicsPushButton = QPushButton("Epics Get PVs")
        epicsPushButton.setDefault(True)
        epicsPushButton.clicked.connect(self.getEpics)
        self.tempEdit = QLineEdit('14.5')
        validator = QDoubleValidator()  # Create validator.
        validator.setRange( -10.0, 100.0, 2)
        self.tempEdit.setValidator(validator)
        self.pv901Offset = QLineEdit('0.15')

        pressPushButton = QPushButton("Calc Press")
        pressPushButton.setDefault(True)
        pressPushButton.clicked.connect(self.sumPress)
        layout = QGridLayout() # QVBoxLayout()
        layout.addWidget(radioButton1, 0, 0)
        layout.addWidget(radioButton2, 0, 1)
        layout.addWidget(epicsPushButton, 1, 0)
        layout.addWidget(pressPushButton, 1, 1)
        layout.addWidget(QLabel('MFC601 Temp'), 2, 0)
        layout.addWidget(self.tempEdit, 2, 1)
        layout.addWidget(QLabel('PV901 Offset'), 3, 0)
        layout.addWidget(self.pv901Offset, 3, 1)
        #layout.addWidget(checkBox)
        #layout.setRowStretch(2, 1)
        #layout.addStretch(1)
        self.topLeftGroupBox.setLayout(layout)

    def sumPress(self):
        tPfill = float(self.tableGasFill.item(0,0).text())
        tHe = float(self.tableGasFill.item(0,1).text())
        tH2 = float(self.tableGasFill.item(0,2).text())
        tO2 = float(self.tableGasFill.item(0,3).text())
        pSum = tHe + tH2 + tO2
        #print(f"Sum Value: {pSum}")
        pPartAmbHe = tPfill * tHe / pSum
        self.tableGasFill.setItem(1,1, QTableWidgetItem(f'{pPartAmbHe:0.2f}'))
        pPartAmbH2 = tPfill * tH2 / pSum
        self.tableGasFill.setItem(1,2, QTableWidgetItem(f'{pPartAmbH2:0.2f}'))
        pPartAmbO2 = tPfill * tO2 / pSum
        self.tableGasFill.setItem(1,3, QTableWidgetItem(f'{pPartAmbO2:0.2f}'))
        tempAbs = self.mfcTemp['601'] + T_REF
       # tempabs = float(self.tempEdit.text())  + T_REF
        pPartRefHe = pPartAmbHe * T_REF / tempAbs
        self.tableGasFill.setItem(2,1, QTableWidgetItem(f'{pPartRefHe:0.2f}'))
        pPartRefH2 = pPartAmbH2 * T_REF / tempAbs
        self.tableGasFill.setItem(2,2, QTableWidgetItem(f'{pPartRefH2:0.2f}'))
        pPartRefO2 = pPartAmbO2 * T_REF / tempAbs
        self.tableGasFill.setItem(2,3, QTableWidgetItem(f'{pPartRefO2:0.2f}'))

        volAmbHe = pPartAmbHe  * VOL_DRIVER
        #volRefHe = pPartRefHe  * VOL_DRIVER
        volRefHe2 = float(self.tableSetPoints.item(1,3).text())
        volAmbHe2 = volRefHe2 * tempAbs / T_REF
        volAmbHe1 = volAmbHe - volAmbHe2 - VOL_DRIVER
        volRefHe1 = volAmbHe1 * T_REF / tempAbs

        volAmbO2 = pPartAmbO2  * VOL_DRIVER
        self.tableSetPoints.setItem(0,0, QTableWidgetItem(f'{volAmbO2:0.2f}'))
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

        fPO2 = self.ptPress['201'] - dPO2
        self.tableSetPoints.setItem(3,0, QTableWidgetItem(f'{fPO2:0.2f}'))
        fPHe1 = self.ptPress['301'] - dPHe1
        self.tableSetPoints.setItem(3,1, QTableWidgetItem(f'{fPHe1:0.2f}'))

        minO2 = volRefO2 / 1e3 / self.mfcFlowSp['201'] * 60
        self.tableSetPoints.setItem(4,0, QTableWidgetItem(f'{minO2:0.2f}'))
        minHe1 = volRefHe1 / self.mfcFlowSp['601']
        self.tableSetPoints.setItem(4,1, QTableWidgetItem(f'{minHe1:0.2f}'))
        minO2 =( 0.8 * volRefO2 / self.mfcFlowSp['201'] + 0.2 * volRefO2 / 0.4) / 1e3 * 60
        self.tableSetPoints.setItem(4,2, QTableWidgetItem(f'{minO2:0.2f}'))

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
        
        mfc601Temp = caget('Esther:gas:' + 'MFC601_FTEMP')
        self.tempEdit.setText(f'{mfc601Temp:0.1f}')
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
                QSizePolicy.Policy.Ignored)

        tab1 = QWidget()
        self.tableGasFill = QTableWidget(3, 4)
        self.tableGasFill.setHorizontalHeaderLabels(("P_Filling","He","H2","O2"))
        self.tableGasFill.setVerticalHeaderLabels(("Target","Partial(R)","Partial(A)"))
        self.tableGasFill.setItem(0,0,QTableWidgetItem("30"))
        self.tableGasFill.setItem(0,1,QTableWidgetItem("7.0"))
        self.tableGasFill.setItem(0,2,QTableWidgetItem("2.0"))
        self.tableGasFill.setItem(0,3,QTableWidgetItem("1.0"))

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

        self.topRightTabWidget.addTab(tab1, "&Target")
        self.topRightTabWidget.addTab(tab2, "&MFCs")

    def createBottomTabWidget(self):
        self.bottomTabWidget = QTabWidget()
        self.bottomTabWidget.setSizePolicy(QSizePolicy.Policy.Preferred,
                QSizePolicy.Policy.Ignored)

        tab1 = QWidget()
        self.tableSetPoints = QTableWidget(5, 4)

        self.tableSetPoints.setHorizontalHeaderLabels(("O2","He1","H2","He2"))
        self.tableSetPoints.setVerticalHeaderLabels(("Litre Ambient","Litre Norm","dP bottle",'Bottle Final Press','Filling min'))
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

if __name__ == '__main__':

    import sys

    app = QApplication(sys.argv)
    gallery = WidgetGasFilling()
    gallery.show()
    sys.exit(app.exec())

# vim: syntax=python ts=4 sw=4 sts=4 sr et
