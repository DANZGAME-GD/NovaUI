uniform vec2 center; 
uniform vec2 resolution;
uniform float time;
uniform vec2 mouse; 
uniform float pulse1;
uniform float pulse2;
uniform float pulse3; 




const int POINTS = 16; 
const float WAVE_OFFSET = 12000.0;
const float SPEED = 1.0 / 12.0;
const float COLOR_SPEED = 1.0 / 4.0;
const float BRIGHTNESS = 1.2;

void voronoi(vec2 uv, inout vec3 col)
{
    vec3 voronoi = vec3(0.0);
    float time = (time + WAVE_OFFSET)*SPEED; 
    float bestDistance = 999.0;		
    float lastBestDistance = bestDistance;	
    for (int i = 0; i < POINTS; i++)		
    {
        float fi = float(i);
        vec2 p = vec2(mod(fi, 1.0) * 0.1 + sin(fi),
                      -0.05 + 0.15 * float(i / 10) + cos(fi + time * cos(uv.x * 0.025)));
        float d = distance(uv, p);
        if (d < bestDistance)
        {
            lastBestDistance = bestDistance;
            bestDistance = d;
            
            
            voronoi.x = p.x;
            voronoi.yz = vec2(p.x * 0.4 + p.y, p.y) * vec2(0.9, 0.87);
        }
    }
    col *= 0.68 + 0.19 * voronoi;	
    col += smoothstep(0.99, 1.05, 1.0 - abs(bestDistance - lastBestDistance)) * 0.9;			
    col += smoothstep(0.95, 1.01, 1.0 - abs(bestDistance - lastBestDistance)) * 0.1 * col;		
    col += (voronoi) * 0.1 * smoothstep(0.5, 1.0, 1.0 - abs(bestDistance - lastBestDistance));	
}

void main(){
    
    vec2 uv = gl_FragCoord/resolution.xy;

    
    vec3 col = 0.5 + 0.5*cos(time*COLOR_SPEED+uv.xyx+vec3(0,2,4));
    
    
    voronoi(uv * 4.0 - 1.0, col); 

    
    gl_FragColor = vec4(col,1.0)*BRIGHTNESS;
}