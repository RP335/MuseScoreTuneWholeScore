import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1



import MuseScore 3.0
MuseScore {
    menuPath: "Plugins.Ratiotuner"
    description: "Description goes here"
    version: "1.0"
    pluginType: "dialog"
    width: 200
    height: 200
    onRun:
    {
        console.log("hello world")
        if (typeof curScore  === 'undefined')
        {
            Qt.quit()

        }
    }
    function applyToNotesInSelection(func)
    {
        var fullScore = !curScore.selection.elements.length
        if (fullScore)
        {
            cmd("select-all")
            curScore.startCmd()
        }
        for (var i in curScore.selection.elements)
            if (curScore.selection.elements[i].pitch)
                func(curScore.selection.elements[i])
        if (fullScore)
        {
                  curScore.endCmd()
                  cmd("escape")
        }
    }
    function addtuning(note)

    {
        var curtuning = note.tuning
        var newcents = desiredcents.text
        if ( (curtuning+newcents)>100)
        {
            note.pitch +=1
            note.tuning  = (curtuning+newcents)-100
        }
        else
            (note.tuning)+= newcents


    }
    function applychanges()
    {
        applyToNotesInSelection(addtuning)
        Qt.quit()
    }





    Rectangle
    {
        color: "lightgrey"
        anchors.fill: parent
        GridLayout
        {
            columns: 1
            anchors.fill: parent
            anchors.margins: 20
            GroupBox
            {
                title: "Enter Desired Tuning (in cents)"
                RowLayout
                {
                    TextField
                    {
                        Layout.maximumWidth: offsetTextWidth
                        id: desiredcents
                        text: "0.00"
                        readOnly: false
                        validator: DoubleValidator { bottom: -99.99; decimals: 2; notation: DoubleValidator.StandardNotation; top:99.99 }
                        property var previousText: "0.00"
                        property var name: "cents"
                    }
                }
            }
            GroupBox{
                title: "Apply Changes/ Quit"
                RowLayout
                {
                    Button {
                        id: applyButton
                        text: qsTranslate("PrefsDialogBase", "Apply")
                        onClicked: {
                            applychanges()
                        }

                    }
                    Button {
                        id: quitbutton
                        text: qsTranslate("PrefsDialogBase", "Quit")
                        onClicked: {
                            Qt.quit()
                        }

                    }
                }

            }
        }
    }
}