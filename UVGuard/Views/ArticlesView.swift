//
//  ArticlesView.swift
//  UVGuard
//
//  UV Protection Articles with Grid Layout
//

import SwiftUI

struct ArticlesView: View {
    let articles = Article.sampleArticles
    @State private var selectedArticle: Article?
    
    // Grid layout configuration
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.uvAccent)
                                .font(.title2)
                            
                            Text("UV Protection")
                                .font(.uvTitle)
                                .uvPrimaryText()
                        }
                        
                        Text("Learn how to protect yourself from harmful UV rays")
                            .font(.uvBody)
                            .uvSecondaryText()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Grid of Article Cards
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(articles) { article in
                            ArticleCard(article: article)
                                .onTapGesture {
                                    selectedArticle = article
                                }
                        }
                    }
                    
                }
                .padding(.bottom)
            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
        }
    }
}

// MARK: - Article Card

struct ArticleCard: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon and Category
            HStack {
                ZStack {
                    Circle()
                        .fill(article.iconColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: article.icon)
                        .font(.title2)
                        .foregroundColor(article.iconColor)
                }
                
                Spacer()
                
                Text(article.category)
                    .font(.uvCaption2)
                    .fontWeight(.medium)
                    .foregroundColor(article.iconColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(article.iconColor.opacity(0.15))
                    .cornerRadius(6)
            }
            
            // Title
            Text(article.title)
                .font(.uvHeadline)
                .fontWeight(.bold)
                .uvPrimaryText()
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            // Summary
            Text(article.summary)
                .font(.uvCaption)
                .uvSecondaryText()
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            // Read Time
            HStack {
                Image(systemName: "clock.fill")
                    .font(.uvCaption2)
                Text(article.readTime)
                    .font(.uvCaption2)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.uvCaption2)
            }
            .uvSecondaryText()
        }
        .padding()
        .frame(height: 220)
        .background(Color.uvCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.uvWarmTan.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Article Detail View

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.uvBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 16) {
                            // Category Badge
                            HStack {
                                Text(article.category)
                                    .font(.uvCaption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(article.iconColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(article.iconColor.opacity(0.15))
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .font(.uvCaption2)
                                    Text(article.readTime)
                                        .font(.uvCaption)
                                }
                                .uvSecondaryText()
                            }
                            
                            // Title
                            Text(article.title)
                                .font(.uvTitle)
                                .fontWeight(.bold)
                                .uvPrimaryText()
                            
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(article.iconColor.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: article.icon)
                                    .font(.system(size: 40))
                                    .foregroundColor(article.iconColor)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Summary
                            Text(article.summary)
                                .font(.uvBody)
                                .uvSecondaryText()
                                .padding()
                                .background(Color.uvCardBackground.opacity(0.5))
                                .cornerRadius(12)
                        }
                        .padding()
                        .modifier(UVCardModifier())
                        
                        // Content Sections
                        ForEach(article.content) { section in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(section.heading)
                                    .font(.uvTitle2)
                                    .fontWeight(.bold)
                                    .uvPrimaryText()
                                
                                Text(section.content)
                                    .font(.uvBody)
                                    .uvSecondaryText()
                                    .lineSpacing(4)
                            }
                            .padding()
                            .modifier(UVCardModifier())
                        }
                        
                        // Quick Tips Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.uvAccent)
                                Text("Quick Tips")
                                    .font(.uvTitle2)
                                    .fontWeight(.bold)
                                    .uvPrimaryText()
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(article.tips.enumerated()), id: \.offset) { index, tip in
                                    HStack(alignment: .top, spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(article.iconColor.opacity(0.2))
                                                .frame(width: 24, height: 24)
                                            
                                            Text("\(index + 1)")
                                                .font(.uvCaption)
                                                .fontWeight(.bold)
                                                .foregroundColor(article.iconColor)
                                        }
                                        
                                        Text(tip)
                                            .font(.uvBody)
                                            .uvPrimaryText()
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                        .padding()
                        .modifier(UVCardModifier())
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.uvSecondaryText)
                            .font(.title3)
                    }
                }
            }
        }
    }
}

#Preview {
    ArticlesView()
}

#Preview("Article Detail") {
    ArticleDetailView(article: Article.sampleArticles[0])
}
