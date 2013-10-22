/* Tiny exporter script: store each frame of animation as an .obj file */
/* Usage: call animax2obj DATA_NAME from Maxscript console */
function animax2obj _name =
(
local i = 1
/* Iterate over the frames */
for t = 0f to 80f do
(
str =""
indexStr = i as string
/* Convert frame index i to string with special notation for first 9 frames */
if (i < 10) then indexStr = "0" + indexStr
str = "Exporting frame " + indexStr + " ..."
print str
/* Adjust slider time */
sliderTime = t
filePath = "D:/Work/fr.unistra.icube-igg/dyndat/" + _name + "/" + _name + "_" + indexStr + ".obj"
/* Do export */
print filePath
exportFile(filePath) #noPrompt selectedOnly:true
i += 1
)
return 0
)