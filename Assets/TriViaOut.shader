Shader "Unlit/TriViaOut"
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
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
			#pragma target 5.0

            #include "UnityCG.cginc"
			
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            struct v2f
            {
                float4 vertex : SV_POSITION;
				float4 coloro : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
				const float bladethick = 4.0;
				float3 rootxyz = float3( v.vertex.x, 0, v.vertex.z );
				const float3 swaymid[4] = {
					float3( 0.0, 0.0, 0.0 ),
					float3( 0.150, 0.333, 0.150 ),
					float3( 0.50, 0.666, 0.50 ),
					float3( 1.0, 1.0, 1.0 ) };
				float3 sway = float3( sin( _Time.y + rootxyz.x ), 1, cos( _Time.y + rootxyz.z) )*.3;
				v2f o;
				uint height = uint(v.vertex.y) % 4;
				float bladesignthick = sign( v.vertex.y > 4.0 )?-bladethick:bladethick;
				o.coloro = frac( float4( rootxyz.x, rootxyz.z, height/4.0, 1.0 )/1.0 );
				o.vertex = UnityObjectToClipPos( float4( rootxyz + bladesignthick*float3( -.01, 0.0, 0.0 )  + sway*swaymid[height], 1.0 ) );
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.coloro;
            }
            ENDCG
        }
    }
}
