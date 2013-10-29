/* Export set of .obj files

Modify end_index

Modify filePath

Do not forget to "Tools->Evaluate all"
*/
/* Usage: call import_obj DATA_NAME from Maxscript console */

function export_obj _name =
(
	/* local i = 1 */
	end_index = 24
	for i = 0 to end_index do
	(
		indexStr = i as string
		fileName = _name + "_" + indexStr	
		filePath = "D:/" + fileName + ".obj"
		/*getNodeByName(fileName)*/		
		theObject = Execute ("$'" + fileName + "'")
		select theObject
		exportFile(filePath) #noPrompt selectedOnly:true
	)
return 0
)