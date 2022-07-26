Shader "Unlit/TriViaTessLoDAbort"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		Cull Off
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geo
			#pragma hull hull
			#pragma domain dom

			#pragma multi_compile_fog
			#pragma target 5.0

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				uint	vertexID	: SV_VertexID;
            };

			struct vtx
			{
				float4 vertex : SV_POSITION;
				uint4 batchID : TEXCOORD0;
			};

            struct g2f
            {
                float4 vertex : SV_POSITION;
				float4 coloro : TEXCOORD0;
            };

            vtx vert (appdata v)
            {
                vtx o;
                o.vertex = v.vertex;
				o.batchID = uint4( v.vertexID, 0, 0, v.vertex.y );
                return o;
            }

			// Divx can be no more than 63x63 divisions
			// 63*63 => Will get us 3,969 iterations. 
			// 32*32 => Will get us 1,024 iterations. << We choose this for convenience.
			#define TESS_DIVX 4
			#define TESS_DIVY 8

			struct tessFactors
			{
				float edgeTess[4] : SV_TessFactor;
				float insideTess[2] : SV_InsideTessFactor;
			};

			tessFactors hullConstant(InputPatch<vtx, 4> I , uint quadID : SV_PrimitiveID)
			{
				tessFactors o = (tessFactors)0;

			//	if (quadID > 1) return o;

				o.edgeTess[0] = 0;
				o.edgeTess[1] = 0;
				o.edgeTess[2] = 0;
				o.edgeTess[3] = 0;
				o.insideTess[0] = TESS_DIVX+1;
				o.insideTess[1] = TESS_DIVY+1;
				o.edgeTess[1] = o.edgeTess[3] = o.insideTess[0];
				o.edgeTess[0] = o.edgeTess[2] = o.insideTess[1];
			   
				return o;
			}
		 
			[domain("quad")]
			[partitioning("integer")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("hullConstant")]
			[outputcontrolpoints(4)]
			vtx hull( InputPatch<vtx, 4> IN, uint uCPID : SV_OutputControlPointID )
			{
				vtx o = (vtx)0;
				o.vertex = IN[uCPID].vertex;
				o.batchID = uint4( IN[uCPID].batchID.xyzw );
				return o;
			}
	 
			[domain("quad")]
			vtx dom( tessFactors HSConstantData, const OutputPatch<vtx, 4> IN, float2 bary : SV_DomainLocation )
			{
				vtx o = (vtx)0;
				o.vertex = IN[0].vertex;
				o.batchID = uint4( IN[0].batchID.x, bary.xy*float2((TESS_DIVX+0.5), (TESS_DIVY+0.5)), IN[0].batchID.w);
				return o;
			}

			[maxvertexcount(8)]
			void geo (point vtx pts[1], inout TriangleStream<g2f> triStream,
				uint instanceID : SV_GSInstanceID )
			{
				const float bladethick = 4.0;
				float3 rootxyzin = pts[0].vertex.xyz;
				uint4 bid = pts[0].batchID;
				float3 rootxyz = rootxyzin + float3( 0, 0, bid.y*8+bid.z )* 6.4;
					//float3( bid.y, 0.0, bid.z ) * 0.1 +
					//float3( bid.w, 0.0, instanceID )*3.2;
				const float3 swaymid0 = float3( 0.150, 0.333, 0.150 );
				const float3 swaymid1 = float3( 0.50, 0.666, 0.50 );
				const float3 swaymid2 = float3( 1.0, 1.0, 1.0 );
				float3 sway = float3( sin( _Time.y + rootxyz.x ), 1, cos( _Time.y + rootxyz.z) )*.3;
				g2f o;
				o.coloro = frac( float4( rootxyz.x, rootxyz.z, 0.0, 1.0 )/1.0 );
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( -.01, 0.0, 0.0 ), 1.0 ) );
				triStream.Append(o);
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( .01, 0.0, 0.0 ), 1.0 ) );
				triStream.Append(o);
				o.coloro.b = 0.333;
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( -.01, 0.0, 0.0 ) + sway*swaymid0, 1.0 ) );
				triStream.Append(o);
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( .01, 0.0, 0.0 ) + sway*swaymid0, 1.0 ) );
				triStream.Append(o);
				o.coloro.b = 0.666;
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( -.01, 0.0, 0.0 ) + sway*swaymid1, 1.0 ) );
				triStream.Append(o);
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( .01, 0.0, 0.0 ) + sway*swaymid1, 1.0 ) );
				triStream.Append(o);
				o.coloro.b = 1.0;
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( -.01, 0.0, 0.0 ) + sway*swaymid2, 1.0 ) );
				triStream.Append(o);
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladethick*float3( .01, 0.0, 0.0 ) + sway*swaymid2, 1.0 ) );
				triStream.Append(o);
				triStream.RestartStrip();
			}



			float4 frag( g2f IN ) : SV_Target
			{
				return IN.coloro.rgba;
			}
			
            ENDCG
        }
    }
}
