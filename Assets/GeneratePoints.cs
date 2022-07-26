using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class GeneratePoints : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
	
	[MenuItem("MyMenu/GeneratePoints")]
    static void GeneratePointSet()
    {
		const int ptx = 2048;
		const int pty = 2048;
		
		Mesh mesh = new Mesh();
		mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
		int[] indices = new int[ptx*pty];
		Vector3[] verts = new Vector3[ptx*pty];
		int x, y;
		for( y = 0; y < pty; y++ )
		{
			for( x = 0; x < ptx; x++ )
			{
				verts[x+y*ptx] = new Vector3( x/10.0f, 0.0f, y/10.0f );
				indices[x+y*ptx] = x+y*ptx;
			}
		}
		
		mesh.vertices = verts;
		mesh.SetIndices(indices, MeshTopology.Points, 0, false, 0);
		AssetDatabase.CreateAsset(mesh, "Assets/points.asset");
    }
	
	[MenuItem("MyMenu/GeneratePointsForInstanced")]
    static void GeneratePointsForInstanced()
    {
		const int ptx = 2048;
		const int pty = 2048/32;
		
		Mesh mesh = new Mesh();
		mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
		int[] indices = new int[ptx*pty];
		Vector3[] verts = new Vector3[ptx*pty];
		int x, y;
		for( y = 0; y < pty; y++ )
		{
			for( x = 0; x < ptx; x++ )
			{
				verts[x+y*ptx] = new Vector3( x/10.0f, 0.0f, y/10.0f );
				indices[x+y*ptx] = x+y*ptx;
			}
		}
		
		mesh.vertices = verts;
		mesh.SetIndices(indices, MeshTopology.Points, 0, false, 0);
		AssetDatabase.CreateAsset(mesh, "Assets/pointsforinstanced.asset");
    }

	[MenuItem("MyMenu/GenerateTriIndividual")]
    static void GenerateTriIndividual()
    {
		const int ptx = 2048;
		const int pty = 2048;
		const int idstride = 18;
		const int vtstride = 8;
		
		Mesh mesh = new Mesh();
		mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
		int[] indices = new int[ptx*pty*idstride];
		Vector3[] verts = new Vector3[ptx*pty*vtstride];
		int x, y;
		for( y = 0; y < pty; y++ )
		{
			for( x = 0; x < ptx; x++ )
			{
				int i;
				int vtbase = (x+y*ptx)*vtstride;
				for( i = 0; i < vtstride; i++ )
				{
					verts[vtbase+i] = new Vector3( x/10.0f, i, y/10.0f );
				}
				indices[(x+y*ptx)*idstride+ 0] = vtbase+0;
				indices[(x+y*ptx)*idstride+ 1] = vtbase+4;
				indices[(x+y*ptx)*idstride+ 2] = vtbase+5;
				indices[(x+y*ptx)*idstride+ 3] = vtbase+5;
				indices[(x+y*ptx)*idstride+ 4] = vtbase+1;
				indices[(x+y*ptx)*idstride+ 5] = vtbase+0;
				indices[(x+y*ptx)*idstride+ 6] = vtbase+1;
				indices[(x+y*ptx)*idstride+ 7] = vtbase+5;
				indices[(x+y*ptx)*idstride+ 8] = vtbase+6;
				indices[(x+y*ptx)*idstride+ 9] = vtbase+6;
				indices[(x+y*ptx)*idstride+10] = vtbase+2;
				indices[(x+y*ptx)*idstride+11] = vtbase+1;
				indices[(x+y*ptx)*idstride+12] = vtbase+2;
				indices[(x+y*ptx)*idstride+13] = vtbase+6;
				indices[(x+y*ptx)*idstride+14] = vtbase+7;
				indices[(x+y*ptx)*idstride+15] = vtbase+7;
				indices[(x+y*ptx)*idstride+16] = vtbase+3;
				indices[(x+y*ptx)*idstride+17] = vtbase+2;
			}
		}
		mesh.vertices = verts;
		mesh.SetIndices(indices, MeshTopology.Triangles, 0, false, 0);
		AssetDatabase.CreateAsset(mesh, "Assets/triangles.asset");
    }

	[MenuItem("MyMenu/GenerateFewPoint")]
    static void GenerateFewPoint()
    {
		const int ptx = 4;
		const int pty = 8;
		
		Mesh mesh = new Mesh();
		mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
		int[] indices = new int[ptx*pty];
		Vector3[] verts = new Vector3[ptx*pty];
		int x, y;
		for( y = 0; y < pty; y++ )
		{
			for( x = 0; x < ptx; x++ )
			{
				verts[x+y*ptx] = new Vector3( x/10.0f, x+y*ptx, y/10.0f );
				indices[x+y*ptx] = x+y*ptx;
			}
		}
		
		mesh.vertices = verts;
		mesh.SetIndices(indices, MeshTopology.Points, 0, false, 0);
		AssetDatabase.CreateAsset(mesh, "Assets/fewpts.asset");
    }

}
