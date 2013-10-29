/* Import set of .obj files

Modify end_index

Modify filePath

Do not forget to "Tools->Evaluate all"
*/
/* Usage: call import_obj DATA_NAME from Maxscript console */

function import_obj _name =
(
	/* local i = 1 */
	end_index = 24
	for i = 0 to end_index do
	(
		indexStr = i as string
		fileName = _name + "_" + indexStr + ".obj"	
		filePath = "D:/Work/Projects/interest-point-fast/fr.unistra.icube-igg.dyndat/cone_negative/obj/" + fileName
		ImportFile filePath #noPrompt
	)
	return 0
)