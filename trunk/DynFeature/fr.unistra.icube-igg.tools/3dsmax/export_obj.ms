/* Export set of .obj files

Modify end_index

Modify filePath

Do not forget to "Tools->Evaluate all"
*/
/* Usage: call import_obj DATA_NAME from Maxscript console */

function export_obj _name  =
(
	export_name = "horse-maya_"
	/* local i = 1 */
	end_index = 80
	for i = 1 to end_index do
	(
		indexStr = i as string
		k = i + 1
		exportIndexStr = k as string
		indexStr = "0" + indexStr
		if i < 10 do indexStr = "0" + indexStr
		fileName = _name + "_" + indexStr	
		filePath = "D:/" + export_name + exportIndexStr + ".obj"
		/*getNodeByName(fileName)*/		
		theObject = Execute ("$'" + fileName + "'")
		select theObject
		exportFile(filePath) #noPrompt selectedOnly:true
	)
return 0
)