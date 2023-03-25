//
//  DetailView.swift
//  StoreSearchApp
//
//  Created by hasung jung on 2023/03/22.
//

import Foundation
import SwiftUI

import Kingfisher

struct ViewOverlayModifier<V: View>: ViewModifier {
    let alignment: Alignment
    let view: () -> V

    init(alignment: Alignment, @ViewBuilder view: @escaping () -> V) {
        self.alignment = alignment
        self.view = view
    }

    func body(content: Content) -> some View {
        content.overlay(view(), alignment: .trailingLastTextBaseline)
    }
}

struct DetailView: View {
    var detail: SearchResult

    @State private var isLimitText = false

    var body: some View {
        NavigationView(content: {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        KFImage(detail.appIcon)
                            .placeholder { Rectangle().fill(.gray.opacity(0.2))   }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)

                        VStack(alignment: .leading) {
                            Text(detail.title).font(.largeTitle)
                            Text(detail.companyName).font(.body).foregroundColor(.gray)
                            Spacer()
                                .frame(height: 20)
                            HStack {
                                Button("받기") {
                                    UIApplication.shared.open(detail.appIcon!)
                                }
                                    .buttonStyle(.borderedProminent)
                                    .cornerRadius(20)
                            }
                        }
                    }.padding()
                    Divider()
                    HStack {
                        RatingView(currentRating: detail.averageUserRating)
                            .foregroundColor(.gray)
                        Divider()
                            .frame(width: 20)
                        Spacer()
                    }.padding()
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(detail.screenshots, id: \.self) { url in
                                KFImage(url)
                                    .placeholder { Rectangle().fill(.gray.opacity(0.2))   }
                                    .cancelOnDisappear(true)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300)
                            }
                        }
                    }.padding()
                    Divider()
                    VStack {
                        Text(detail.description).lineLimit(isLimitText ? nil : 5)
                            .modifier(
                                ViewOverlayModifier(
                                    alignment: .trailingLastTextBaseline,
                                    view: {
                                        Button {
                                            isLimitText = !isLimitText
                                        } label: {
                                            Text(isLimitText ? "줄이기" : "더보기")
                                        }.background(in: Rectangle())
                                    })
                            )
                    }.padding()

                    Divider()
                }
            }
        }).navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            detail: SearchResult(
                id: 12341,
                appIcon: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/6f/e4/42/6fe442a9-9eb2-2ad7-3285-1031b7b9a188/AppIcon-0-1x_U007emarketing-0-6-0-sRGB-0-0-85-220.png/512x512bb.jpg"),
                title: "Amazone Kindle",
                averageUserRating: 4.777777, screenshots: [
                    URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Purple123/v4/a9/4c/d5/a94cd5c7-2a58-42f9-9c13-f30429a4c1a8/mzl.eevunhhw.png/392x696bb.png")!,
                    URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Purple113/v4/38/58/61/3858610f-7b61-a0fd-3438-77bcd2976829/mzl.xvivnoxf.png/392x696bb.png")!,
                    URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/d0/e2/4d/d0e24d2c-cb4f-73c7-53d5-a96c0595d410/mzl.tntuxdtg.png/392x696bb.png")!,
                    URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple123/v4/04/50/3e/04503e38-d7a2-4f3b-9e46-7e9d221a29ef/mzl.juaprnvp.png/392x696bb.png")!,
                    URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/46/3d/e0/463de0dd-d100-2c8d-0dc2-5ef1cb78122a/mzl.fnsnmhif.png/392x696bb.png")!,
                    URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Purple123/v4/44/ed/d0/44edd084-ed43-96f3-7b7a-7bcb047d8504/pr_source.jpg/392x696bb.jpg")!,
                    URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Purple123/v4/36/cc/0e/36cc0eff-664e-b31d-05b9-73381ebe7dea/pr_source.jpg/392x696bb.jpg")!,
                    URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Purple113/v4/f6/12/4e/f6124ecb-292b-0e36-b180-74090c885864/pr_source.jpg/392x696bb.jpg")!
                ],
                companyName: "Test.com",
                releaseNotes: "YouVersion을 사용하여 매일 하나님을 찾는 것을 기쁘게 생각합니다!\n\n새로운 기능은 다음과 같습니다.\n\n이제 홈 화면에 Streaks 위젯을 추가하여 매일 하나님께 더 가까이 다가가도록 상기시켜 줄 수 있습니다.",
                description: "세계적으로 1억 8천 대가 넘는 기기로 사람들이 무료 성경 앱을 사용해 말씀을 읽고, 듣고, 보고, 나누고 있습니다. 수백 가지 언어로 된 1천 가지 이상의 번역본을 보유하고 있습니다.  40여 가지 언어로 된 수백 편의 묵상 계획을 제공합니다. 나만의 성경 이미지, 하이라이트, 책갈피, 공개 노트와 비공개 노트를 지원합니다.자신에게 맞는 성경읽기를 체험하실 수 있습니다. 온라인으로 모든 기능을 사용할 수 있고, 일부 번역본은 다운로드받아 오프라인에서 사용할 수 있습니다.\n\n성경 앱으로 가장 가까운 친구들과 함께 성경을 탐구할 수 있습니다. 본인이 믿고 신뢰하는 공동체 식구들과 말씀에 대해 솔직한 대화를 나눠 보세요. 그들이 탐구한 내용을 보며 함께 말씀을 배우세요.\n\n성경읽기\n*30여 가지 언어 중 원하는 언어를 선택해 성경 앱 인터페이스를 조정하세요.\n수백 가지 언어로 된 775개 이상의 성경 번역본 중에서 선택하세요.* 인기있는 번역본인 개역한글, 새번역, 현대인의 성경, NIV, NASB, ESV, NKJV, NLT, KJV, The Message 등을 선택할 수 있습니다. * 오프라인 성경: 네트워크 연결 없이 성경을 읽을 수 있습니다(일부번역본만 가능).* 오디오 성경으로 말씀을 들으며 건너뛰기, 다시듣기, 속도 및 타이머 조정 기능을 사용해 보세요. (오디오 성경은 일부 번역본에서만 지원하며 다운로드가 불가함).\n\n 친구들과 함께 성경 읽기 \n * 친밀한 사람들과의 관계 중심에 성경을 놓을 수 있습니다 \n * 친구들의 활동, 노트, 책갈피, 하이라이트를 볼 수 있습니다 \n * 하나님의 말씀을 함께 공부하며 댓글을 통해 여러분의 생각을 나누고, 질문을 하고, 의미있는 대화를 나눌 수 있습니다.\n\n성경공부\n * 수백개의 묵상 계획: 묵상을 비롯해 일정한 주제나 말씀구절 혹은 성경전체를 일년 안에 읽을 수 있습니다.* '성경' TV 미니시리즈와 세상을 변화시키는 영화인 '예수,' '루모 프로젝트'를 감상하고 영상을 나눌 수 있습니다. * 키워드 이용해 말씀 찾기.\n\n성경 설정\n*완전히 새로운 테마로 성경 앱 전체에서 색깔 팔레트를 선택하실 수 있습니다.\n* 말씀 이미지: 성경 말씀을 이미지로 만들어 공유하세요.\n* 개인 성경처럼 사용자 지정 색깔로 하이라이트하세요.\n* 북마크: 북마크로 말씀을 공유, 암송하거나 좋아하는 구절을 표시하세요.\n* 소셜 네트워크, 이메일, 문자 메시지로 친구들과 말씀을 나누세요.\n* 노트 추가하기: 자신만 볼 수 있는 비공개 노트를 쓰거나, 친구들과 공유할 수 있는 공개 노트를 만들 수 있습니다.\n* 무료 YouVersion 계정이 있으면 지원 가능한 기기에서 클라우드 동기화를 통해 자신의 노트 전체, 하이라이트, 북마크, 성경 계획을 볼 수 있습니다.\n* 폰트, 글자 크기, 명암 조절 등을 설정해 말씀을 더 쉽게 읽을 수 있습니다.\n\nYouVersion과 연결하기\n* 성경 앱에서 직접 지원할 수 있습니다.\n* 페이스북에서 좋아요를 눌러 주세요. http://facebook.com/youversion\n* 트위터에서 팔로우해 주세요. http://twitter.com/youversion\n* 블로그를 이용해 주세요. http://blog.youversion.com\n* 온라인 YouVersion을 사용해 주세요: http://bible.com\n\n최고 점수를 받은 성경 앱을 지금 다운로드해서 수백만 회원이 사용하며 즐기는 성경을 경험해 보세요!"))
    }
}
