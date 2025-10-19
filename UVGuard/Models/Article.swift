//
//  Article.swift
//  UVGuard
//
//  UV Protection Articles Model
//

import SwiftUI

struct Article: Identifiable {
    let id: Int
    let title: String
    let category: String
    let icon: String
    let iconColor: Color
    let readTime: String
    let summary: String
    let content: [ArticleSection]
    let tips: [String]
}

struct ArticleSection: Identifiable {
    let id = UUID()
    let heading: String
    let content: String
}

// MARK: - Sample Articles Data

extension Article {
    static let sampleArticles: [Article] = [
        Article(
            id: 1,
            title: "Sunscreen Protection Guide",
            category: "Sun Protection",
            icon: "sun.max.fill",
            iconColor: .uvOrangeHighlight,
            readTime: "5 min read",
            summary: "Learn how to choose and apply sunscreen effectively for maximum UV protection.",
            content: [
                ArticleSection(
                    heading: "Why Sunscreen Matters",
                    content: "Sunscreen is your first line of defense against harmful UV rays. It helps prevent sunburn, premature aging, and reduces the risk of skin cancer. The key is choosing the right sunscreen and applying it correctly."
                ),
                ArticleSection(
                    heading: "Choosing the Right SPF",
                    content: "SPF (Sun Protection Factor) indicates how well a sunscreen protects against UVB rays. SPF 30 blocks about 97% of UVB rays, while SPF 50 blocks about 98%. For daily use, SPF 30 is sufficient, but outdoor activities require SPF 50 or higher."
                ),
                ArticleSection(
                    heading: "Broad Spectrum Protection",
                    content: "Always choose broad-spectrum sunscreen that protects against both UVA and UVB rays. UVA rays cause premature aging, while UVB rays cause sunburn. Both contribute to skin cancer risk."
                ),
                ArticleSection(
                    heading: "Application Technique",
                    content: "Apply sunscreen 15-30 minutes before sun exposure. Use about 1 ounce (shot glass full) for your entire body. Don't forget often-missed areas like ears, neck, tops of feet, and hands."
                ),
                ArticleSection(
                    heading: "Reapplication is Key",
                    content: "Reapply sunscreen every 2 hours, or immediately after swimming or sweating. Even water-resistant sunscreen loses effectiveness after 40-80 minutes in water."
                )
            ],
            tips: [
                "Apply sunscreen even on cloudy days - UV rays penetrate clouds",
                "Use separate face and body sunscreens for better skin compatibility",
                "Check expiration dates - sunscreen loses effectiveness over time",
                "Store sunscreen in a cool place, not in hot cars",
                "Apply lip balm with SPF 30 or higher for lip protection"
            ]
        ),
        
        Article(
            id: 2,
            title: "UV Protection Clothing",
            category: "Protective Gear",
            icon: "tshirt.fill",
            iconColor: .uvAccent,
            readTime: "4 min read",
            summary: "Discover how UV-protective clothing can shield your skin from harmful sun exposure.",
            content: [
                ArticleSection(
                    heading: "Understanding UPF Ratings",
                    content: "UPF (Ultraviolet Protection Factor) measures how much UV radiation penetrates fabric. UPF 50 blocks 98% of UV rays, allowing only 1/50th of UV to reach your skin. Look for UPF 30+ for good protection."
                ),
                ArticleSection(
                    heading: "Best Fabrics for UV Protection",
                    content: "Tightly woven synthetic fabrics like polyester and nylon offer excellent UV protection. Dark colors absorb more UV than light colors. Wet fabric provides less protection than dry fabric."
                ),
                ArticleSection(
                    heading: "Essential UV Protective Gear",
                    content: "Invest in a wide-brimmed hat (3+ inches) to protect face, ears, and neck. Wear UV-blocking sunglasses with 100% UV protection. Consider UV-protective swim shirts for water activities."
                ),
                ArticleSection(
                    heading: "Layering Strategy",
                    content: "Base layer should be lightweight, moisture-wicking fabric with UPF rating. Add a long-sleeved shirt or light jacket for extra protection. Choose clothes with built-in UV protection for outdoor activities."
                )
            ],
            tips: [
                "Wear long sleeves and pants when UV index is high",
                "Choose tightly woven fabrics - hold up to light to check",
                "Wash UV-protective clothing according to instructions",
                "Replace worn-out clothing as protection decreases",
                "Combine protective clothing with sunscreen for maximum protection"
            ]
        ),
        
        Article(
            id: 3,
            title: "UV Defense Umbrellas",
            category: "Sun Protection",
            icon: "umbrella.fill",
            iconColor: .purple,
            readTime: "3 min read",
            summary: "Learn about UV-blocking umbrellas and how they provide portable shade protection.",
            content: [
                ArticleSection(
                    heading: "UV Umbrellas vs Regular Umbrellas",
                    content: "UV-blocking umbrellas have special coatings that block 95-99% of UV rays, while regular umbrellas only block about 50%. The difference is significant for sun protection."
                ),
                ArticleSection(
                    heading: "Key Features to Look For",
                    content: "Choose umbrellas with UPF 50+ rating. Black or dark-colored canopies provide better protection. Silver-coated inner lining reflects heat and UV rays. Compact size makes them portable for daily use."
                ),
                ArticleSection(
                    heading: "Effective Usage Tips",
                    content: "Hold the umbrella at an angle toward the sun, not just overhead. UV rays can reflect off surfaces, so combine with sunscreen. Use during peak UV hours (10 AM - 4 PM) for maximum benefit."
                ),
                ArticleSection(
                    heading: "When to Use UV Umbrellas",
                    content: "Perfect for beach outings, outdoor events, waiting for buses, or walking in intense sun. Particularly useful when UV index is 6 or higher. Great alternative when shade isn't available."
                )
            ],
            tips: [
                "Choose umbrellas with multiple layers for better UV blocking",
                "Test UV protection by holding it up to bright light",
                "Clean your UV umbrella regularly to maintain coating",
                "Store in a dry place to prevent coating damage",
                "Don't rely solely on umbrellas - combine with other protection"
            ]
        ),
        
        Article(
            id: 4,
            title: "Peak UV Hours Awareness",
            category: "Safety Tips",
            icon: "clock.fill",
            iconColor: .uvDanger,
            readTime: "3 min read",
            summary: "Understand when UV radiation is strongest and how to plan your outdoor activities.",
            content: [
                ArticleSection(
                    heading: "The 10-4 Rule",
                    content: "UV radiation is strongest between 10 AM and 4 PM. During these hours, up to 60% of daily UV exposure occurs. Plan indoor activities during peak hours when possible."
                ),
                ArticleSection(
                    heading: "Shadow Rule Guideline",
                    content: "If your shadow is shorter than you, UV radiation is very high. When your shadow is longer than your height, UV radiation is lower. This simple rule helps gauge sun intensity."
                ),
                ArticleSection(
                    heading: "Seasonal Variations",
                    content: "UV levels are highest in late spring and early summer. However, don't let winter fool you - snow reflects up to 80% of UV rays, increasing exposure. Altitude also matters - UV increases 10-12% per 1,000 feet elevation."
                ),
                ArticleSection(
                    heading: "Planning Your Day",
                    content: "Schedule outdoor activities before 10 AM or after 4 PM. If you must be outside during peak hours, seek shade frequently. Take breaks indoors or under cover every hour."
                )
            ],
            tips: [
                "Check the UV index forecast daily through UVGuard app",
                "Set reminders to reapply sunscreen during outdoor activities",
                "Seek shade under trees, buildings, or use portable shade",
                "Wear protective gear even on cloudy days",
                "Be extra cautious near water, sand, and snow due to reflection"
            ]
        ),
        
        Article(
            id: 5,
            title: "Vitamin D Balance",
            category: "Health",
            icon: "heart.fill",
            iconColor: .pink,
            readTime: "4 min read",
            summary: "Find the right balance between sun protection and vitamin D synthesis.",
            content: [
                ArticleSection(
                    heading: "The Vitamin D Dilemma",
                    content: "Our bodies need sunlight to produce vitamin D, essential for bone health, immune function, and mood regulation. However, excessive UV exposure increases skin cancer risk. Finding balance is crucial."
                ),
                ArticleSection(
                    heading: "Safe Sun Exposure",
                    content: "10-15 minutes of midday sun exposure on arms and legs, 2-3 times per week, is usually sufficient for vitamin D synthesis. People with darker skin may need more time."
                ),
                ArticleSection(
                    heading: "Alternative Vitamin D Sources",
                    content: "Fatty fish (salmon, mackerel), fortified milk, egg yolks, and supplements provide vitamin D without sun exposure risks. Consider vitamin D3 supplements, especially in winter months."
                ),
                ArticleSection(
                    heading: "Window Glass Effect",
                    content: "UVB rays (needed for vitamin D) don't penetrate window glass, but UVA rays (causing aging) do. Sitting by a window won't boost vitamin D but can still cause skin damage."
                )
            ],
            tips: [
                "Get vitamin D levels checked by your doctor annually",
                "Consider vitamin D supplements (1000-2000 IU daily)",
                "Brief unprotected exposure is better than prolonged protected exposure",
                "Eat vitamin D-rich foods regularly",
                "Consult a healthcare provider for personalized advice"
            ]
        ),
        
        Article(
            id: 6,
            title: "After-Sun Skin Care",
            category: "Skin Care",
            icon: "waveform.path.ecg",
            iconColor: .green,
            readTime: "4 min read",
            summary: "Essential steps to care for your skin after sun exposure and treat mild sunburn.",
            content: [
                ArticleSection(
                    heading: "Immediate Care",
                    content: "Cool your skin with a cold compress or cool bath within the first few hours. Avoid ice directly on skin. Drink plenty of water to rehydrate from inside out."
                ),
                ArticleSection(
                    heading: "Moisturize and Soothe",
                    content: "Apply aloe vera gel or after-sun lotion to soothe and hydrate skin. Look for products with ingredients like aloe, chamomile, or hyaluronic acid. Avoid petroleum-based products that trap heat."
                ),
                ArticleSection(
                    heading: "Treat Sunburn",
                    content: "For mild sunburn, apply cool compresses and take ibuprofen to reduce inflammation. Use hydrocortisone cream for itching. Stay out of the sun until skin heals completely."
                ),
                ArticleSection(
                    heading: "Long-term Recovery",
                    content: "Continue moisturizing for several days after sun exposure. Don't peel or scratch damaged skin. Watch for signs of sun poisoning: severe pain, blisters, fever, or chills - seek medical attention if these occur."
                )
            ],
            tips: [
                "Avoid hot showers after sun exposure - use lukewarm water",
                "Wear loose, soft clothing to prevent irritation",
                "Take cool baths with colloidal oatmeal for relief",
                "Avoid further sun exposure until skin fully heals",
                "See a doctor if sunburn covers large areas or blisters severely"
            ]
        )
    ]
}
