/* Import set of .obj files

Modify end_index

Modify filePath

Do not forget to "Tools->Evaluate all"
*/
/* Usage: call import_obj DATA_NAME from Maxscript console */

function import_obj _name =
(
	/* local i = 1 */
	start_index = 1
	end_index = 80
	for i = start_index to end_index do
	(
		indexStr = i as string
		fileName = _name + "." + indexStr + ".obj"	
		filePath = "d:/Work/Projects/interest-point-fast/fr.unistra.icube-igg.dyndat/horse_maya/obj/" + fileName
		ImportFile filePath #noPrompt
	)
	return 0
)