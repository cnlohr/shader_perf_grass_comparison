# shader_perf_grass_comparison
Fake test for checking perf of different shader types.

Deliberately obtuse data to see how video cards process different video render pipeline stuff.

Things I learned: The naïve vertex-only approach is **slower** than geometry shaders.  Not by much.

* 4 M Blades of grass with **vertex shader**: ~16ms.  (Mesh In->Mesh Out) (the worst)
* 4 M Blades of grass with **geometry shader**: ~13ms.  (Points In->Mesh Out)

--- not suitable for grass, but fun to test ---

* 4 M Blades of grass with **instanced geometry shader**: ~13ms.  (Points In->Mesh Out)
* 4 M Blades of grass with mixed **tessellation shader** / instanced geo: ~13ms.  (Points In->Mesh Out)

(Profiling done with my underclocked 3090 (running at 210MHz (as underclocked as I can get it)) 

I also now understand why someone would want to use tessellation or compute shaders in this case.  It makes it reasonable to do LoD culling, and emit less grass.  Whereas geometry shaders would be helplessly inefficient at that.

* 64 M Blades of grass with all but 4M culled with **geometry shader**: ~45ms.  (Points In->Mesh Out)

tl;dr:
geometry shaders seem fine, as expected, don't use them for heavy LoD.
streaming massive vertex buffers is slower than you would expect.


