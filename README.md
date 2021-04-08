# Ipelets

## Involute drawer

An ipelet for drawing aproximated ipelets. Select a mark and a path, the Ipelet will produce a clockwise or counter-clockwise involute originating from the selected mark that is evolute to the selected path.
   
The produced involute is represented as a path and 100 units long. If the involute needs to be longer, it can be modified in the code or a second involute can be drawn from the end of the previous involute by placing a new mark there.

## T-splitter

Very simple Ipelet that takes two selected paths that share a point that is the beginning or end of one path and is a point halfway the other path, creating a T-shape. The Ipelet will split the latter path by creating two new paths for each half.
