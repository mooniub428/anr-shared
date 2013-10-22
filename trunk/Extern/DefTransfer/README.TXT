Hi Vasyl,

I attached the cat/lion and horse/camel correspondence files. I believe these are the ones I used in the siggraph paper, but if you notice anything strangle, like the triangle ID's not matching the OBJ files you have, let me know.

The file format is pretty simple. They are text files. There's a fixed header "bob 5 cor 1". Then, there is one line for each target triangle. These lines first list the target triangle ID, followed by the source triangle ID(s) to which this target triangle corresponds. For these two cases, the cat and horse are the source shapes, and the lion and camel are the target shapes.

One note, is that the .cor files are 0-indexed. I also pasted the code I used to parse these files, in case that helps.

It would be great if you could include an acknowledgement about deformation transfer in your papers that use this data, and I'd love to hear how your work turns out!

Let me know if you need anything else.

Best regards,
Bob



// ---------- Cor::OpenForRead ------------------------------------------

FILE *Cor::OpenForRead(const std::string &filename) {

  // Copy the filename
  _filename = filename;

  // Load the cor file
  FILE *stream = fopen(filename.c_str(), "r");

  if (stream == NULL) {
    LogError("Error: Can't open file \"%s\".\n", filename.c_str());
    exit(-1);
  }

  // Check the header
  // The file should begin with:
  // bob 5 cor <version>

  char word[256];
  fscanf(stream, "%s", word);
  if (strcmp(word, "bob")) {
    LogError("Error: \"bob\" not found in file \"%s\". (%s)\n", filename.c_str(), word);
    fclose(stream);
    exit(-1);
  }

  fscanf(stream, "%s", word);
  if (atoi(word) != 5) {
    LogError("Error: File id %d should be 5 in \"%s\".\n", atoi(word), filename.c_str());
    fclose(stream);
    exit(-1);
  }

  fscanf(stream, "%s", word);
  if (strcmp(word, "cor")) {
    LogError("Error: File type \"%s\" should be \"cor\" in \"%s\".\n", word, filename.c_str());
    fclose(stream);
    exit(-1);
  }

  fscanf(stream, "%s", word);
  _fileVersion = atoi(word);

  return stream;
}

// ---------- Cor::LoadVersion1 -----------------------------------------

void Cor::LoadVersion1(FILE *stream) {

  // Note: This isn't the best parser.  It fails if there are tabs
  // separating the numbers rather than spaces.  Or if there are extra
  // spaces anywhere.  (There should be exactly one space inbetween
  // the numbers and non at the end of the line.)

  for (int i = 0; i < _targetSize; i++) {
    int index;
    fscanf(stream, "%d", &index);

    //printf("index=%d i=%d\n", index, i);

    assert(index == i);

    char c;
    int num;
    while (1) {
      fscanf(stream, "%c", &c);
      if (c != ' ')
        break;

      fscanf(stream, "%d", &num);

      //printf("--> %d\n", num);

      assert(num >= 0);
      assert(num < _sourceSize);

      _data[i].push_back(num);
      _total++;
	   }
  }
}