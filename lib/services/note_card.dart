import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notepad/services/app_style.dart';
Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc){
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[doc['color_id']],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(doc["note_title"],style: AppStyle.mainTitle,),
          Text(doc["creation_date"], style: AppStyle.dateTitle,),
          Text(doc["note_content"],style: AppStyle.mainContent,),
        ],
      ),
    ),
  );
}