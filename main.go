// Command screenshot is a chromedp example demonstrating how to take a
// screenshot of a specific element and of the entire browser viewport.
package main

import (
    "context"
    "io/ioutil"
    "log"
    "time"

    "github.com/chromedp/chromedp"
)

func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()

    allocCtx, cancel := chromedp.NewExecAllocator(ctx, append(chromedp.DefaultExecAllocatorOptions[:],
        chromedp.Flag("no-sandbox", true),
    )...)
    defer cancel()

    taskCtx, cancel := chromedp.NewContext(allocCtx)
    defer cancel()

    screenshot, err := captureScreenshot(taskCtx)
    if err != nil {
        log.Fatal(err)
    }

    err = ioutil.WriteFile("/tmp/screenshot.png", screenshot, 0644)
    if err != nil {
        log.Fatalf("error writing screenshot to file: %v", err)
    }

    log.Println("Saved screenshot as ./tmp/screenshot.png")
}

func captureScreenshot(ctx context.Context) ([]byte, error) {
    var buf []byte

    err := chromedp.Run(ctx,
        chromedp.Navigate(`https://example.com`),
        chromedp.CaptureScreenshot(&buf),
    )

    return buf, err
}
