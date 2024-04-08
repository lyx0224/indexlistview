import display from '@ohos.display'
import { CityType, CITY_DATA } from './DetailData'

@Component
export struct IndexCityListView {
  clickCallback?: (city: string) => void
  private mScroller: Scroller = new Scroller()
  @State y: number = 0
  @State currentLetter: string = ''
  @State pressDown: boolean = false
  @State scrollIndex: number = 0
  private screenHeight = 0
  private letterHeight = 40
  private letterTopList: number[] = []

  aboutToAppear(): void {
    this.screenHeight = getScreenHeight()
    let marginTop = (this.screenHeight - this.letterHeight * CITY_DATA.length) / 2
    CITY_DATA.forEach((_: CityType, index: number) => {
      this.letterTopList[index] = marginTop + (index * this.letterHeight)
    })
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      this.cityList()
      this.indexList()
      this.centerView()
    }
  }

  @Builder
  cityList() {
    // 城市列表
    Column() {
      List({ space: 14, initialIndex: 0, scroller: this.mScroller }) {
        ForEach(CITY_DATA, (index: CityType) => {
          ListItem() {
            Column() {
              //字母
              Text(`${index.name}`)
                .height('30vp')
                .fontSize('16fp')
                .fontColor($r('app.color.text_font_color'))
                .width('100%')
                .backgroundColor($r('app.color.lineColor'))
              //字母城市
              ForEach(index.city, (item: string) => {
                Text(item)
                  .height('30vp')
                  .fontSize('14fp')
                  .width('100%')
                  .onClick(() => {
                    if (this.clickCallback) {
                      this.clickCallback(item)
                    }
                  })
              })
            }
          }
        })
      }
      .edgeEffect(EdgeEffect.None)
      .divider({
        strokeWidth: 2, color: $r('app.color.divider_color'),
        startMargin: 0, endMargin: 20
      })
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        this.scrollIndex = firstIndex
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  @Builder
  indexList() {
    //right
    Column() {
      ForEach(CITY_DATA, (item: CityType, index: number) => {
        Text(item.name)
          .textAlign(TextAlign.Center)
          .height(this.letterHeight)
          .width('100%')
          .fontColor($r('app.color.primaryColor'))
          .onTouch((event) => {
            if (event.type == TouchType.Move) {
              this.y = event.touches[0].windowY
              let findIndex = this.findMovePositionLetterIndex(this.y)
              if (findIndex != -1) {
                this.currentLetter = CITY_DATA[findIndex].name
                this.mScroller.scrollToIndex(findIndex)
              }
            } else if (event.type == TouchType.Down) {
              this.pressDown = true
            } else if (event.type == TouchType.Up) {
              this.pressDown = false
            }
          })

      })
    }.width('30vp')
    .border({
      radius: 10
    })
    .margin({ right: 4 })
    .backgroundColor(this.pressDown ? $r('app.color.lineColor') : Color.Transparent)
  }

  @Builder
  centerView() {
    if (this.scrollIndex >= 0 && this.scrollIndex <= CITY_DATA.length - 1) {
      Column() {
        Column() {
          Text(`${CITY_DATA[this.scrollIndex].name}`)
            .fontColor($r('app.color.primaryColor'))
            .fontSize('30fp')
            .fontWeight(FontWeight.Bold)
        }.width('100vp')
        .height('100vp')
        .justifyContent(FlexAlign.Center)
        .border({
          width: '1vp',
          color: $r('app.color.primaryColor'),
          radius: 4
        })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .visibility(this.pressDown ? Visibility.Visible : Visibility.Hidden)
    }
  }

  findMovePositionLetterIndex(y: number) {
    for (let i = 0; i < this.letterTopList.length; i++) {
      let top = this.letterTopList[i]
      if (y >= top && y <= top + this.letterHeight) {
        return i
      }
    }
    return -1
  }
}

function getScreenHeight(): number {
  try {
    let displayClass = display.getDefaultDisplaySync();
    return px2vp(displayClass.height);
  } catch (exception) {
    console.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
  }
  return 0;
}
