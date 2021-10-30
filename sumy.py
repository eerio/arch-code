from __future__ import annotations
from typing import Optional


class TreeNode:
    key: int
    left: Optional[TreeNode]
    right: Optional[TreeNode]
    aux: int

    def __init__(self, key: int, left: Optional[TreeNode],
            right: Optional[TreeNode], aux: int=-1):
        self.key = key
        self.left = left
        self.right = right
        self.aux = aux

#   10
# 5     20
#      13 23
tree = TreeNode(
        10,
        TreeNode(5, None, None),
        TreeNode(20, TreeNode(13, None, None), TreeNode(23, None, None)),
)


def set_sizes(root: Optional[TreeNode]) -> None:
    # postorder
    stack = [(False, root)]
    
    while stack:
        visiting, node = stack.pop()

        if not node:
            continue
        
        if visiting:
            node.aux = 1 + (node.left.aux if node.left else 0) + (node.right.aux if node.right else 0)
        else:
            stack.append((True, node))
            stack.append((False, node.right))
            stack.append((False, node.left))

set_sizes(tree)

print(tree.aux, tree.left.aux, tree.right.aux, tree.right.left.aux, tree.right.right.aux)
# $ python3 sumy.py
# 5 1 3 1 1
