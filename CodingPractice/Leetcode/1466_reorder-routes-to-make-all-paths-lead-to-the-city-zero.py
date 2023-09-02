class Solution:
    def minReorder(self, n: int, connections: List[List[int]]) -> int:
        # build connection matrix
        matrix = [[] for _ in range(n)]
        for edge in connections:
            matrix[edge[0]].append((edge[1],1))
            matrix[edge[1]].append((edge[0],-1))
        stack = [0]
        result = 0
        visited = [False] * n
        while stack:
            node = stack.pop(0)
            visited[node] = True
            neighbors = []
            for neighbor in matrix[node]:
                neigh_node,neigh_direction = neighbor
                if visited[neigh_node]==False:
                    neighbors.append(neigh_node)
                    if neigh_direction==1:
                        result +=1                      
            if neighbors:
                stack.extend(neighbors)



        return result



        