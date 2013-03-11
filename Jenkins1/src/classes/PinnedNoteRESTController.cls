@RestResource(urlMapping='/v1.0/pipeline/pinned_note')

global class PinnedNoteRESTController{
@HttpPut
    global static void addPinnedNote(string id, string note){
        PerfectPipeline.addPinnedNotes(id,note);
      }
}