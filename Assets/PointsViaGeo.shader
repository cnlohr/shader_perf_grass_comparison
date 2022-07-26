Shader "Unlit/PointsViaGeo"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			Cull Off
			
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geo
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
			#pragma target 5.0

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

			struct v2g
			{
				float4 posdata : SV_POSITION;
			};
			
            struct g2f
            {
                float4 vertex : SV_POSITION;
				float4 coloro : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2g vert (appdata v)
            {
                v2g o;
                o.posdata = v.vertex;
                return o;
            }

			[maxvertexcount(8)]
			void geo (point v2g pts[1], inout TriangleStream<g2f> triStream )
			{
				const float bladethick = 4.0;
				float3 rootxyz = pts[0].posdata.xyz;
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

            fixed4 frag (g2f i) : SV_Target
            {
                return i.coloro;
            }
            ENDCG
        }
    }
}
