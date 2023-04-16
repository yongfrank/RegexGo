//
//  FlowLayout.swift
//  
//
//  Created by Chu Yong on 4/15/23.
//

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A flow layout for SwiftUI's layout.
*/

import SwiftUI

//struct FlowLayout: Layout {
//    var alignment: Alignment = .center
//    var spacing: CGFloat?
//    
//    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
//        <#code#>
//    }
//    
//    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//        <#code#>
//    }
//    
//    struct FlowResult {
//        var bounds = CGSize.zero
//        var rows = [Row]()
//        
//        struct Row {
//            var range: Range<Int>
//            var xOffsets: [Double]
//            var frame: CGRect
//        }
//        
//        init(in maxPossibleWidth: Double, subviews: Subviews, alignment: Alignment, spacing: CGFloat?) {
//            var itemsInRow = 0
//            var remainingWidth = maxPossibleWidth.isFinite ? maxPossibleWidth : .greatestFiniteMagnitude
//            var rowMinY = 0.0
//            var rowHeight = 0.0
//            var xOffsets: [Double] = []
//            for (index, subview) in zip(subviews.indices, subviews) {
//                let idealSize = subview.sizeThatFits(.unspecified)
//                if index != 0 && widthInRow(index: index, idealWidth: idealSize.width) > remainingWidth {
//                    // Finish the current row without this subview.
////                    finalizeRow()
//                }
//            }
//            
//            
//            func widthInRow(index: Int, idealWidth: Double) -> Double {
//                idealWidth + spacingBefore(index: index)
//            }
//            
//            func spacingBefore(index: Int) -> Double {
//                guard itemsInRow > 0 else { return 0 }
//                return spacing ?? subviews[index - 1].spacing.distance(to: subviews[index].spacing, along: .horizontal)
//            }
//            
//            func finalizeRow(index: Int, idealSize: CGSize) {
//                let rowWidth = maxPossibleWidth - remainingWidth
//                rows.append(
//                    Row(range: index - max(itemsInRow - 1, 0) ..< index + 1, xOffsets: xOffsets, frame: CGRect(x: 0, y: rowMinY, width: rowWidth, height: rowHeight))
//                )
//                bounds.width = max(bounds.width, rowWidth)
////                let ySpacing = spacing ?? ViewSpacing().distance(to: )
//            }
//        }
//        
//        
//    }
//}
//
//struct FlowLayout_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowLayout()
//    }
//}
