import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

// Fix some of the weirdness in PlasmaComponents.Label
// https://github.com/KDE/plasma-framework/blob/master/src/declarativeimports/plasmacomponents/qml/Label.qml
PlasmaComponents.Label {
	height: paintedHeight // Plasma sets the minHeight to 1.6*fontHeight
}
